Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745Ab2EJPHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:07:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:36602 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756452Ab2EJPHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:07:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="141431584"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] Xen physical cpus interface (V2)
Thread-Topic: [PATCH 3/3] Xen physical cpus interface (V2)
Thread-Index: Ac0uvnBnJV8RtIigTTax7Uicx2M6Kw==
Date: Thu, 10 May 2012 15:06:14 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351B58A3@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923351B58A3SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923351B58A3SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 7aa4cf7c1172e24611dc76163397b8708acacc59 Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Fri, 11 May 2012 06:55:35 +0800
Subject: [PATCH 3/3] Xen physical cpus interface

Manage physical cpus in dom0, get physical cpus info and provide sys interf=
ace.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
---
 .../ABI/testing/sysfs-devices-system-xen_cpu       |   20 +
 drivers/xen/Makefile                               |    1 +
 drivers/xen/pcpu.c                                 |  374 ++++++++++++++++=
++++
 include/xen/interface/platform.h                   |    8 +
 include/xen/interface/xen.h                        |    1 +
 5 files changed, 404 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-system-xen_cpu
 create mode 100644 drivers/xen/pcpu.c

diff --git a/Documentation/ABI/testing/sysfs-devices-system-xen_cpu b/Docum=
entation/ABI/testing/sysfs-devices-system-xen_cpu
new file mode 100644
index 0000000..9ca02fb
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-system-xen_cpu
@@ -0,0 +1,20 @@
+What:		/sys/devices/system/xen_cpu/
+Date:		May 2012
+Contact:	Liu, Jinsong <jinsong.liu@intel.com>
+Description:
+		A collection of global/individual Xen physical cpu attributes
+
+		Individual physical cpu attributes are contained in
+		subdirectories named by the Xen's logical cpu number, e.g.:
+		/sys/devices/system/xen_cpu/xen_cpu#/
+
+
+What:		/sys/devices/system/xen_cpu/xen_cpu#/online
+Date:		May 2012
+Contact:	Liu, Jinsong <jinsong.liu@intel.com>
+Description:
+		Interface to online/offline Xen physical cpus
+
+		When running under Xen platform, it provide user interface
+		to online/offline physical cpus, except cpu0 due to several
+		logic restrictions and assumptions.
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
index 0000000..9014ff1
--- /dev/null
+++ b/drivers/xen/pcpu.c
@@ -0,0 +1,374 @@
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
+#include <linux/capability.h>
+
+#include <xen/xen.h>
+#include <xen/xenbus.h>
+#include <xen/events.h>
+#include <xen/interface/platform.h>
+#include <asm/xen/hypervisor.h>
+#include <asm/xen/hypercall.h>
+
+#define XEN_PCPU "xen_cpu: "
+
+/*
+ * @cpu_id: Xen physical cpu logic number
+ * @flags: Xen physical cpu status flag
+ * - XEN_PCPU_FLAGS_ONLINE: cpu is online
+ * - XEN_PCPU_FLAGS_INVALID: cpu is not present
+ */
+struct pcpu {
+	struct list_head list;
+	struct device dev;
+	uint32_t cpu_id;
+	uint32_t flags;
+};
+
+static struct bus_type xen_pcpu_subsys =3D {
+	.name =3D "xen_cpu",
+	.dev_name =3D "xen_cpu",
+};
+
+static DEFINE_MUTEX(xen_pcpu_lock);
+
+static LIST_HEAD(xen_pcpus);
+
+static int xen_pcpu_down(uint32_t cpu_id)
+{
+	struct xen_platform_op op =3D {
+		.cmd			=3D XENPF_cpu_offline,
+		.interface_version	=3D XENPF_INTERFACE_VERSION,
+		.u.cpu_ol.cpuid		=3D cpu_id,
+	};
+
+	return HYPERVISOR_dom0_op(&op);
+}
+
+static int xen_pcpu_up(uint32_t cpu_id)
+{
+	struct xen_platform_op op =3D {
+		.cmd			=3D XENPF_cpu_online,
+		.interface_version	=3D XENPF_INTERFACE_VERSION,
+		.u.cpu_ol.cpuid		=3D cpu_id,
+	};
+
+	return HYPERVISOR_dom0_op(&op);
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
+	struct pcpu *pcpu =3D container_of(dev, struct pcpu, dev);
+	unsigned long long val;
+	ssize_t ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (kstrtoull(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	switch (val) {
+	case 0:
+		ret =3D xen_pcpu_down(pcpu->cpu_id);
+		break;
+	case 1:
+		ret =3D xen_pcpu_up(pcpu->cpu_id);
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
+static struct pcpu *get_pcpu(uint32_t cpu_id)
+{
+	struct list_head *cur;
+	struct pcpu *pcpu;
+
+	list_for_each(cur, &xen_pcpus) {
+		pcpu =3D list_entry(cur, struct pcpu, list);
+		if (pcpu->cpu_id =3D=3D cpu_id)
+			return pcpu;
+	}
+
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
+
+	device_unregister(dev);
+}
+
+static void free_pcpu(struct pcpu *pcpu)
+{
+	if (!pcpu)
+		return;
+
+	pcpu_sys_remove(pcpu);
+
+	list_del(&pcpu->list);
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
+	dev->id =3D pcpu->cpu_id;
+
+	err =3D device_register(dev);
+	if (err)
+		return err;
+
+	/*
+	 * Xen never offline cpu0 due to several restrictions
+	 * and assumptions. This basically doesn't add a sys control
+	 * to user, one cannot attempt to offline BSP.
+	 */
+	if (dev->id) {
+		err =3D device_create_file(dev, &dev_attr_online);
+		if (err) {
+			device_unregister(dev);
+			return err;
+		}
+	}
+
+	return 0;
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
+	INIT_LIST_HEAD(&pcpu->list);
+	pcpu->cpu_id =3D info->xen_cpuid;
+	pcpu->flags =3D info->flags;
+
+	err =3D pcpu_sys_create(pcpu);
+	if (err) {
+		pr_warning(XEN_PCPU "Failed to register pcpu%u\n",
+			   info->xen_cpuid);
+		kfree(pcpu);
+		return ERR_PTR(-ENOENT);
+	}
+
+	/* Need hold on xen_pcpu_lock before pcpu list manipulations */
+	list_add_tail(&pcpu->list, &xen_pcpus);
+	return pcpu;
+}
+
+/*
+ * Caller should hold the xen_pcpu_lock
+ */
+static int sync_pcpu(uint32_t cpu, uint32_t *max_cpu)
+{
+	int ret;
+	struct pcpu *pcpu =3D NULL;
+	struct xenpf_pcpuinfo *info;
+	struct xen_platform_op op =3D {
+		.cmd                   =3D XENPF_get_cpuinfo,
+		.interface_version     =3D XENPF_INTERFACE_VERSION,
+		.u.pcpu_info.xen_cpuid =3D cpu,
+	};
+
+	ret =3D HYPERVISOR_dom0_op(&op);
+	if (ret)
+		return ret;
+
+	info =3D &op.u.pcpu_info;
+	if (max_cpu)
+		*max_cpu =3D info->max_present;
+
+	pcpu =3D get_pcpu(cpu);
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
+	uint32_t cpu =3D 0, max_cpu =3D 0;
+	int err =3D 0;
+	struct list_head *cur, *tmp;
+	struct pcpu *pcpu;
+
+	mutex_lock(&xen_pcpu_lock);
+
+	while (!err && (cpu <=3D max_cpu)) {
+		err =3D sync_pcpu(cpu, &max_cpu);
+		cpu++;
+	}
+
+	if (err) {
+		list_for_each_safe(cur, tmp, &xen_pcpus) {
+			pcpu =3D list_entry(cur, struct pcpu, list);
+			free_pcpu(pcpu);
+		}
+	}
+
+	mutex_unlock(&xen_pcpu_lock);
+
+	return err;
+}
+
+static void xen_pcpu_work_fn(struct work_struct *work)
+{
+	xen_sync_pcpus();
+}
+static DECLARE_WORK(xen_pcpu_work, xen_pcpu_work_fn);
+
+static irqreturn_t xen_pcpu_interrupt(int irq, void *dev_id)
+{
+	schedule_work(&xen_pcpu_work);
+	return IRQ_HANDLED;
+}
+
+static int __init xen_pcpu_init(void)
+{
+	int irq, ret;
+
+	if (!xen_initial_domain())
+		return -ENODEV;
+
+	irq =3D bind_virq_to_irqhandler(VIRQ_PCPU_STATE, 0,
+				      xen_pcpu_interrupt, 0,
+				      "xen-pcpu", NULL);
+	if (irq < 0) {
+		pr_warning(XEN_PCPU "Failed to bind pcpu virq\n");
+		return irq;
+	}
+
+	ret =3D subsys_system_register(&xen_pcpu_subsys, NULL);
+	if (ret) {
+		pr_warning(XEN_PCPU "Failed to register pcpu subsys\n");
+		goto err1;
+	}
+
+	ret =3D xen_sync_pcpus();
+	if (ret) {
+		pr_warning(XEN_PCPU "Failed to sync pcpu info\n");
+		goto err2;
+	}
+
+	return 0;
+
+err2:
+	bus_unregister(&xen_pcpu_subsys);
+err1:
+	unbind_from_irqhandler(irq, NULL);
+	return ret;
+}
+arch_initcall(xen_pcpu_init);
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platf=
orm.h
index 486653f..61fa661 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
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

--_002_DE8DF0795D48FD4CA783C40EC82923351B58A3SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0003-Xen-physical-cpus-interface.patch"
Content-Description: 0003-Xen-physical-cpus-interface.patch
Content-Disposition: attachment;
	filename="0003-Xen-physical-cpus-interface.patch"; size=12603;
	creation-date="Thu, 10 May 2012 15:03:13 GMT";
	modification-date="Thu, 10 May 2012 22:58:00 GMT"
Content-Transfer-Encoding: base64

RnJvbSA3YWE0Y2Y3YzExNzJlMjQ2MTFkYzc2MTYzMzk3Yjg3MDhhY2FjYzU5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogRnJpLCAxMSBNYXkgMjAxMiAwNjo1NTozNSArMDgwMApTdWJqZWN0OiBbUEFUQ0ggMy8z
XSBYZW4gcGh5c2ljYWwgY3B1cyBpbnRlcmZhY2UKCk1hbmFnZSBwaHlzaWNhbCBjcHVzIGluIGRv
bTAsIGdldCBwaHlzaWNhbCBjcHVzIGluZm8gYW5kIHByb3ZpZGUgc3lzIGludGVyZmFjZS4KClNp
Z25lZC1vZmYtYnk6IExpdSwgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpTaWduZWQt
b2ZmLWJ5OiBKaWFuZywgWXVuaG9uZyA8eXVuaG9uZy5qaWFuZ0BpbnRlbC5jb20+Ci0tLQogLi4u
L0FCSS90ZXN0aW5nL3N5c2ZzLWRldmljZXMtc3lzdGVtLXhlbl9jcHUgICAgICAgfCAgIDIwICsK
IGRyaXZlcnMveGVuL01ha2VmaWxlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAg
MSArCiBkcml2ZXJzL3hlbi9wY3B1LmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8
ICAzNzQgKysrKysrKysrKysrKysrKysrKysKIGluY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9y
bS5oICAgICAgICAgICAgICAgICAgIHwgICAgOCArCiBpbmNsdWRlL3hlbi9pbnRlcmZhY2UveGVu
LmggICAgICAgICAgICAgICAgICAgICAgICB8ICAgIDEgKwogNSBmaWxlcyBjaGFuZ2VkLCA0MDQg
aW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKIGNyZWF0ZSBtb2RlIDEwMDY0NCBEb2N1bWVu
dGF0aW9uL0FCSS90ZXN0aW5nL3N5c2ZzLWRldmljZXMtc3lzdGVtLXhlbl9jcHUKIGNyZWF0ZSBt
b2RlIDEwMDY0NCBkcml2ZXJzL3hlbi9wY3B1LmMKCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9u
L0FCSS90ZXN0aW5nL3N5c2ZzLWRldmljZXMtc3lzdGVtLXhlbl9jcHUgYi9Eb2N1bWVudGF0aW9u
L0FCSS90ZXN0aW5nL3N5c2ZzLWRldmljZXMtc3lzdGVtLXhlbl9jcHUKbmV3IGZpbGUgbW9kZSAx
MDA2NDQKaW5kZXggMDAwMDAwMC4uOWNhMDJmYgotLS0gL2Rldi9udWxsCisrKyBiL0RvY3VtZW50
YXRpb24vQUJJL3Rlc3Rpbmcvc3lzZnMtZGV2aWNlcy1zeXN0ZW0teGVuX2NwdQpAQCAtMCwwICsx
LDIwIEBACitXaGF0OgkJL3N5cy9kZXZpY2VzL3N5c3RlbS94ZW5fY3B1LworRGF0ZToJCU1heSAy
MDEyCitDb250YWN0OglMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4KK0Rlc2Ny
aXB0aW9uOgorCQlBIGNvbGxlY3Rpb24gb2YgZ2xvYmFsL2luZGl2aWR1YWwgWGVuIHBoeXNpY2Fs
IGNwdSBhdHRyaWJ1dGVzCisKKwkJSW5kaXZpZHVhbCBwaHlzaWNhbCBjcHUgYXR0cmlidXRlcyBh
cmUgY29udGFpbmVkIGluCisJCXN1YmRpcmVjdG9yaWVzIG5hbWVkIGJ5IHRoZSBYZW4ncyBsb2dp
Y2FsIGNwdSBudW1iZXIsIGUuZy46CisJCS9zeXMvZGV2aWNlcy9zeXN0ZW0veGVuX2NwdS94ZW5f
Y3B1Iy8KKworCitXaGF0OgkJL3N5cy9kZXZpY2VzL3N5c3RlbS94ZW5fY3B1L3hlbl9jcHUjL29u
bGluZQorRGF0ZToJCU1heSAyMDEyCitDb250YWN0OglMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1
QGludGVsLmNvbT4KK0Rlc2NyaXB0aW9uOgorCQlJbnRlcmZhY2UgdG8gb25saW5lL29mZmxpbmUg
WGVuIHBoeXNpY2FsIGNwdXMKKworCQlXaGVuIHJ1bm5pbmcgdW5kZXIgWGVuIHBsYXRmb3JtLCBp
dCBwcm92aWRlIHVzZXIgaW50ZXJmYWNlCisJCXRvIG9ubGluZS9vZmZsaW5lIHBoeXNpY2FsIGNw
dXMsIGV4Y2VwdCBjcHUwIGR1ZSB0byBzZXZlcmFsCisJCWxvZ2ljIHJlc3RyaWN0aW9ucyBhbmQg
YXNzdW1wdGlvbnMuCmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi9NYWtlZmlsZSBiL2RyaXZlcnMv
eGVuL01ha2VmaWxlCmluZGV4IDFkM2U3NjMuLmQxMmQxNGQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
eGVuL01ha2VmaWxlCisrKyBiL2RyaXZlcnMveGVuL01ha2VmaWxlCkBAIC0xOSw2ICsxOSw3IEBA
IG9iai0kKENPTkZJR19YRU5fUFZIVk0pCQkJKz0gcGxhdGZvcm0tcGNpLm8KIG9iai0kKENPTkZJ
R19YRU5fVE1FTSkJCQkrPSB0bWVtLm8KIG9iai0kKENPTkZJR19TV0lPVExCX1hFTikJCSs9IHN3
aW90bGIteGVuLm8KIG9iai0kKENPTkZJR19YRU5fRE9NMCkJCQkrPSBwY2kubworb2JqLSQoQ09O
RklHX1hFTl9ET00wKQkJCSs9IHBjcHUubwogb2JqLSQoQ09ORklHX1hFTl9QQ0lERVZfQkFDS0VO
RCkJKz0geGVuLXBjaWJhY2svCiBvYmotJChDT05GSUdfWEVOX1BSSVZDTUQpCQkrPSB4ZW4tcHJp
dmNtZC5vCiBvYmotJChDT05GSUdfWEVOX0FDUElfUFJPQ0VTU09SKQkrPSB4ZW4tYWNwaS1wcm9j
ZXNzb3IubwpkaWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4vcGNwdS5jIGIvZHJpdmVycy94ZW4vcGNw
dS5jCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLjkwMTRmZjEKLS0tIC9kZXYv
bnVsbAorKysgYi9kcml2ZXJzL3hlbi9wY3B1LmMKQEAgLTAsMCArMSwzNzQgQEAKKy8qKioqKioq
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
bHVkZSA8bGludXgvY2FwYWJpbGl0eS5oPgorCisjaW5jbHVkZSA8eGVuL3hlbi5oPgorI2luY2x1
ZGUgPHhlbi94ZW5idXMuaD4KKyNpbmNsdWRlIDx4ZW4vZXZlbnRzLmg+CisjaW5jbHVkZSA8eGVu
L2ludGVyZmFjZS9wbGF0Zm9ybS5oPgorI2luY2x1ZGUgPGFzbS94ZW4vaHlwZXJ2aXNvci5oPgor
I2luY2x1ZGUgPGFzbS94ZW4vaHlwZXJjYWxsLmg+CisKKyNkZWZpbmUgWEVOX1BDUFUgInhlbl9j
cHU6ICIKKworLyoKKyAqIEBjcHVfaWQ6IFhlbiBwaHlzaWNhbCBjcHUgbG9naWMgbnVtYmVyCisg
KiBAZmxhZ3M6IFhlbiBwaHlzaWNhbCBjcHUgc3RhdHVzIGZsYWcKKyAqIC0gWEVOX1BDUFVfRkxB
R1NfT05MSU5FOiBjcHUgaXMgb25saW5lCisgKiAtIFhFTl9QQ1BVX0ZMQUdTX0lOVkFMSUQ6IGNw
dSBpcyBub3QgcHJlc2VudAorICovCitzdHJ1Y3QgcGNwdSB7CisJc3RydWN0IGxpc3RfaGVhZCBs
aXN0OworCXN0cnVjdCBkZXZpY2UgZGV2OworCXVpbnQzMl90IGNwdV9pZDsKKwl1aW50MzJfdCBm
bGFnczsKK307CisKK3N0YXRpYyBzdHJ1Y3QgYnVzX3R5cGUgeGVuX3BjcHVfc3Vic3lzID0gewor
CS5uYW1lID0gInhlbl9jcHUiLAorCS5kZXZfbmFtZSA9ICJ4ZW5fY3B1IiwKK307CisKK3N0YXRp
YyBERUZJTkVfTVVURVgoeGVuX3BjcHVfbG9jayk7CisKK3N0YXRpYyBMSVNUX0hFQUQoeGVuX3Bj
cHVzKTsKKworc3RhdGljIGludCB4ZW5fcGNwdV9kb3duKHVpbnQzMl90IGNwdV9pZCkKK3sKKwlz
dHJ1Y3QgeGVuX3BsYXRmb3JtX29wIG9wID0geworCQkuY21kCQkJPSBYRU5QRl9jcHVfb2ZmbGlu
ZSwKKwkJLmludGVyZmFjZV92ZXJzaW9uCT0gWEVOUEZfSU5URVJGQUNFX1ZFUlNJT04sCisJCS51
LmNwdV9vbC5jcHVpZAkJPSBjcHVfaWQsCisJfTsKKworCXJldHVybiBIWVBFUlZJU09SX2RvbTBf
b3AoJm9wKTsKK30KKworc3RhdGljIGludCB4ZW5fcGNwdV91cCh1aW50MzJfdCBjcHVfaWQpCit7
CisJc3RydWN0IHhlbl9wbGF0Zm9ybV9vcCBvcCA9IHsKKwkJLmNtZAkJCT0gWEVOUEZfY3B1X29u
bGluZSwKKwkJLmludGVyZmFjZV92ZXJzaW9uCT0gWEVOUEZfSU5URVJGQUNFX1ZFUlNJT04sCisJ
CS51LmNwdV9vbC5jcHVpZAkJPSBjcHVfaWQsCisJfTsKKworCXJldHVybiBIWVBFUlZJU09SX2Rv
bTBfb3AoJm9wKTsKK30KKworc3RhdGljIHNzaXplX3Qgc2hvd19vbmxpbmUoc3RydWN0IGRldmlj
ZSAqZGV2LAorCQkJICAgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsCisJCQkgICBjaGFy
ICpidWYpCit7CisJc3RydWN0IHBjcHUgKmNwdSA9IGNvbnRhaW5lcl9vZihkZXYsIHN0cnVjdCBw
Y3B1LCBkZXYpOworCisJcmV0dXJuIHNwcmludGYoYnVmLCAiJXVcbiIsICEhKGNwdS0+ZmxhZ3Mg
JiBYRU5fUENQVV9GTEFHU19PTkxJTkUpKTsKK30KKworc3RhdGljIHNzaXplX3QgX19yZWYgc3Rv
cmVfb25saW5lKHN0cnVjdCBkZXZpY2UgKmRldiwKKwkJCQkgIHN0cnVjdCBkZXZpY2VfYXR0cmli
dXRlICphdHRyLAorCQkJCSAgY29uc3QgY2hhciAqYnVmLCBzaXplX3QgY291bnQpCit7CisJc3Ry
dWN0IHBjcHUgKnBjcHUgPSBjb250YWluZXJfb2YoZGV2LCBzdHJ1Y3QgcGNwdSwgZGV2KTsKKwl1
bnNpZ25lZCBsb25nIGxvbmcgdmFsOworCXNzaXplX3QgcmV0OworCisJaWYgKCFjYXBhYmxlKENB
UF9TWVNfQURNSU4pKQorCQlyZXR1cm4gLUVQRVJNOworCisJaWYgKGtzdHJ0b3VsbChidWYsIDAs
ICZ2YWwpIDwgMCkKKwkJcmV0dXJuIC1FSU5WQUw7CisKKwlzd2l0Y2ggKHZhbCkgeworCWNhc2Ug
MDoKKwkJcmV0ID0geGVuX3BjcHVfZG93bihwY3B1LT5jcHVfaWQpOworCQlicmVhazsKKwljYXNl
IDE6CisJCXJldCA9IHhlbl9wY3B1X3VwKHBjcHUtPmNwdV9pZCk7CisJCWJyZWFrOworCWRlZmF1
bHQ6CisJCXJldCA9IC1FSU5WQUw7CisJfQorCisJaWYgKHJldCA+PSAwKQorCQlyZXQgPSBjb3Vu
dDsKKwlyZXR1cm4gcmV0OworfQorc3RhdGljIERFVklDRV9BVFRSKG9ubGluZSwgU19JUlVHTyB8
IFNfSVdVU1IsIHNob3dfb25saW5lLCBzdG9yZV9vbmxpbmUpOworCitzdGF0aWMgYm9vbCB4ZW5f
cGNwdV9vbmxpbmUodWludDMyX3QgZmxhZ3MpCit7CisJcmV0dXJuICEhKGZsYWdzICYgWEVOX1BD
UFVfRkxBR1NfT05MSU5FKTsKK30KKworc3RhdGljIHZvaWQgcGNwdV9vbmxpbmVfc3RhdHVzKHN0
cnVjdCB4ZW5wZl9wY3B1aW5mbyAqaW5mbywKKwkJCSAgICAgICBzdHJ1Y3QgcGNwdSAqcGNwdSkK
K3sKKwlpZiAoeGVuX3BjcHVfb25saW5lKGluZm8tPmZsYWdzKSAmJgorCSAgICF4ZW5fcGNwdV9v
bmxpbmUocGNwdS0+ZmxhZ3MpKSB7CisJCS8qIHRoZSBwY3B1IGlzIG9ubGluZWQgKi8KKwkJcGNw
dS0+ZmxhZ3MgfD0gWEVOX1BDUFVfRkxBR1NfT05MSU5FOworCQlrb2JqZWN0X3VldmVudCgmcGNw
dS0+ZGV2LmtvYmosIEtPQkpfT05MSU5FKTsKKwl9IGVsc2UgaWYgKCF4ZW5fcGNwdV9vbmxpbmUo
aW5mby0+ZmxhZ3MpICYmCisJCSAgICB4ZW5fcGNwdV9vbmxpbmUocGNwdS0+ZmxhZ3MpKSB7CisJ
CS8qIFRoZSBwY3B1IGlzIG9mZmxpbmVkICovCisJCXBjcHUtPmZsYWdzICY9IH5YRU5fUENQVV9G
TEFHU19PTkxJTkU7CisJCWtvYmplY3RfdWV2ZW50KCZwY3B1LT5kZXYua29iaiwgS09CSl9PRkZM
SU5FKTsKKwl9Cit9CisKK3N0YXRpYyBzdHJ1Y3QgcGNwdSAqZ2V0X3BjcHUodWludDMyX3QgY3B1
X2lkKQoreworCXN0cnVjdCBsaXN0X2hlYWQgKmN1cjsKKwlzdHJ1Y3QgcGNwdSAqcGNwdTsKKwor
CWxpc3RfZm9yX2VhY2goY3VyLCAmeGVuX3BjcHVzKSB7CisJCXBjcHUgPSBsaXN0X2VudHJ5KGN1
ciwgc3RydWN0IHBjcHUsIGxpc3QpOworCQlpZiAocGNwdS0+Y3B1X2lkID09IGNwdV9pZCkKKwkJ
CXJldHVybiBwY3B1OworCX0KKworCXJldHVybiBOVUxMOworfQorCitzdGF0aWMgdm9pZCBwY3B1
X3N5c19yZW1vdmUoc3RydWN0IHBjcHUgKnBjcHUpCit7CisJc3RydWN0IGRldmljZSAqZGV2Owor
CisJaWYgKCFwY3B1KQorCQlyZXR1cm47CisKKwlkZXYgPSAmcGNwdS0+ZGV2OworCWlmIChkZXYt
PmlkKQorCQlkZXZpY2VfcmVtb3ZlX2ZpbGUoZGV2LCAmZGV2X2F0dHJfb25saW5lKTsKKworCWRl
dmljZV91bnJlZ2lzdGVyKGRldik7Cit9CisKK3N0YXRpYyB2b2lkIGZyZWVfcGNwdShzdHJ1Y3Qg
cGNwdSAqcGNwdSkKK3sKKwlpZiAoIXBjcHUpCisJCXJldHVybjsKKworCXBjcHVfc3lzX3JlbW92
ZShwY3B1KTsKKworCWxpc3RfZGVsKCZwY3B1LT5saXN0KTsKKwlrZnJlZShwY3B1KTsKK30KKwor
c3RhdGljIGludCBwY3B1X3N5c19jcmVhdGUoc3RydWN0IHBjcHUgKnBjcHUpCit7CisJc3RydWN0
IGRldmljZSAqZGV2OworCWludCBlcnIgPSAtRUlOVkFMOworCisJaWYgKCFwY3B1KQorCQlyZXR1
cm4gZXJyOworCisJZGV2ID0gJnBjcHUtPmRldjsKKwlkZXYtPmJ1cyA9ICZ4ZW5fcGNwdV9zdWJz
eXM7CisJZGV2LT5pZCA9IHBjcHUtPmNwdV9pZDsKKworCWVyciA9IGRldmljZV9yZWdpc3Rlcihk
ZXYpOworCWlmIChlcnIpCisJCXJldHVybiBlcnI7CisKKwkvKgorCSAqIFhlbiBuZXZlciBvZmZs
aW5lIGNwdTAgZHVlIHRvIHNldmVyYWwgcmVzdHJpY3Rpb25zCisJICogYW5kIGFzc3VtcHRpb25z
LiBUaGlzIGJhc2ljYWxseSBkb2Vzbid0IGFkZCBhIHN5cyBjb250cm9sCisJICogdG8gdXNlciwg
b25lIGNhbm5vdCBhdHRlbXB0IHRvIG9mZmxpbmUgQlNQLgorCSAqLworCWlmIChkZXYtPmlkKSB7
CisJCWVyciA9IGRldmljZV9jcmVhdGVfZmlsZShkZXYsICZkZXZfYXR0cl9vbmxpbmUpOworCQlp
ZiAoZXJyKSB7CisJCQlkZXZpY2VfdW5yZWdpc3RlcihkZXYpOworCQkJcmV0dXJuIGVycjsKKwkJ
fQorCX0KKworCXJldHVybiAwOworfQorCitzdGF0aWMgc3RydWN0IHBjcHUgKmluaXRfcGNwdShz
dHJ1Y3QgeGVucGZfcGNwdWluZm8gKmluZm8pCit7CisJc3RydWN0IHBjcHUgKnBjcHU7CisJaW50
IGVycjsKKworCWlmIChpbmZvLT5mbGFncyAmIFhFTl9QQ1BVX0ZMQUdTX0lOVkFMSUQpCisJCXJl
dHVybiBFUlJfUFRSKC1FTk9ERVYpOworCisJcGNwdSA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBw
Y3B1KSwgR0ZQX0tFUk5FTCk7CisJaWYgKCFwY3B1KQorCQlyZXR1cm4gRVJSX1BUUigtRU5PTUVN
KTsKKworCUlOSVRfTElTVF9IRUFEKCZwY3B1LT5saXN0KTsKKwlwY3B1LT5jcHVfaWQgPSBpbmZv
LT54ZW5fY3B1aWQ7CisJcGNwdS0+ZmxhZ3MgPSBpbmZvLT5mbGFnczsKKworCWVyciA9IHBjcHVf
c3lzX2NyZWF0ZShwY3B1KTsKKwlpZiAoZXJyKSB7CisJCXByX3dhcm5pbmcoWEVOX1BDUFUgIkZh
aWxlZCB0byByZWdpc3RlciBwY3B1JXVcbiIsCisJCQkgICBpbmZvLT54ZW5fY3B1aWQpOworCQlr
ZnJlZShwY3B1KTsKKwkJcmV0dXJuIEVSUl9QVFIoLUVOT0VOVCk7CisJfQorCisJLyogTmVlZCBo
b2xkIG9uIHhlbl9wY3B1X2xvY2sgYmVmb3JlIHBjcHUgbGlzdCBtYW5pcHVsYXRpb25zICovCisJ
bGlzdF9hZGRfdGFpbCgmcGNwdS0+bGlzdCwgJnhlbl9wY3B1cyk7CisJcmV0dXJuIHBjcHU7Cit9
CisKKy8qCisgKiBDYWxsZXIgc2hvdWxkIGhvbGQgdGhlIHhlbl9wY3B1X2xvY2sKKyAqLworc3Rh
dGljIGludCBzeW5jX3BjcHUodWludDMyX3QgY3B1LCB1aW50MzJfdCAqbWF4X2NwdSkKK3sKKwlp
bnQgcmV0OworCXN0cnVjdCBwY3B1ICpwY3B1ID0gTlVMTDsKKwlzdHJ1Y3QgeGVucGZfcGNwdWlu
Zm8gKmluZm87CisJc3RydWN0IHhlbl9wbGF0Zm9ybV9vcCBvcCA9IHsKKwkJLmNtZCAgICAgICAg
ICAgICAgICAgICA9IFhFTlBGX2dldF9jcHVpbmZvLAorCQkuaW50ZXJmYWNlX3ZlcnNpb24gICAg
ID0gWEVOUEZfSU5URVJGQUNFX1ZFUlNJT04sCisJCS51LnBjcHVfaW5mby54ZW5fY3B1aWQgPSBj
cHUsCisJfTsKKworCXJldCA9IEhZUEVSVklTT1JfZG9tMF9vcCgmb3ApOworCWlmIChyZXQpCisJ
CXJldHVybiByZXQ7CisKKwlpbmZvID0gJm9wLnUucGNwdV9pbmZvOworCWlmIChtYXhfY3B1KQor
CQkqbWF4X2NwdSA9IGluZm8tPm1heF9wcmVzZW50OworCisJcGNwdSA9IGdldF9wY3B1KGNwdSk7
CisKKwlpZiAoaW5mby0+ZmxhZ3MgJiBYRU5fUENQVV9GTEFHU19JTlZBTElEKSB7CisJCS8qIFRo
ZSBwY3B1IGhhcyBiZWVuIHJlbW92ZWQgKi8KKwkJaWYgKHBjcHUpCisJCQlmcmVlX3BjcHUocGNw
dSk7CisJCXJldHVybiAwOworCX0KKworCWlmICghcGNwdSkgeworCQlwY3B1ID0gaW5pdF9wY3B1
KGluZm8pOworCQlpZiAoSVNfRVJSX09SX05VTEwocGNwdSkpCisJCQlyZXR1cm4gLUVOT0RFVjsK
Kwl9IGVsc2UKKwkJcGNwdV9vbmxpbmVfc3RhdHVzKGluZm8sIHBjcHUpOworCisJcmV0dXJuIDA7
Cit9CisKKy8qCisgKiBTeW5jIGRvbTAncyBwY3B1IGluZm9ybWF0aW9uIHdpdGggeGVuIGh5cGVy
dmlzb3IncworICovCitzdGF0aWMgaW50IHhlbl9zeW5jX3BjcHVzKHZvaWQpCit7CisJLyoKKwkg
KiBCb290IGNwdSBhbHdheXMgaGF2ZSBjcHVfaWQgMCBpbiB4ZW4KKwkgKi8KKwl1aW50MzJfdCBj
cHUgPSAwLCBtYXhfY3B1ID0gMDsKKwlpbnQgZXJyID0gMDsKKwlzdHJ1Y3QgbGlzdF9oZWFkICpj
dXIsICp0bXA7CisJc3RydWN0IHBjcHUgKnBjcHU7CisKKwltdXRleF9sb2NrKCZ4ZW5fcGNwdV9s
b2NrKTsKKworCXdoaWxlICghZXJyICYmIChjcHUgPD0gbWF4X2NwdSkpIHsKKwkJZXJyID0gc3lu
Y19wY3B1KGNwdSwgJm1heF9jcHUpOworCQljcHUrKzsKKwl9CisKKwlpZiAoZXJyKSB7CisJCWxp
c3RfZm9yX2VhY2hfc2FmZShjdXIsIHRtcCwgJnhlbl9wY3B1cykgeworCQkJcGNwdSA9IGxpc3Rf
ZW50cnkoY3VyLCBzdHJ1Y3QgcGNwdSwgbGlzdCk7CisJCQlmcmVlX3BjcHUocGNwdSk7CisJCX0K
Kwl9CisKKwltdXRleF91bmxvY2soJnhlbl9wY3B1X2xvY2spOworCisJcmV0dXJuIGVycjsKK30K
Kworc3RhdGljIHZvaWQgeGVuX3BjcHVfd29ya19mbihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmsp
Cit7CisJeGVuX3N5bmNfcGNwdXMoKTsKK30KK3N0YXRpYyBERUNMQVJFX1dPUksoeGVuX3BjcHVf
d29yaywgeGVuX3BjcHVfd29ya19mbik7CisKK3N0YXRpYyBpcnFyZXR1cm5fdCB4ZW5fcGNwdV9p
bnRlcnJ1cHQoaW50IGlycSwgdm9pZCAqZGV2X2lkKQoreworCXNjaGVkdWxlX3dvcmsoJnhlbl9w
Y3B1X3dvcmspOworCXJldHVybiBJUlFfSEFORExFRDsKK30KKworc3RhdGljIGludCBfX2luaXQg
eGVuX3BjcHVfaW5pdCh2b2lkKQoreworCWludCBpcnEsIHJldDsKKworCWlmICgheGVuX2luaXRp
YWxfZG9tYWluKCkpCisJCXJldHVybiAtRU5PREVWOworCisJaXJxID0gYmluZF92aXJxX3RvX2ly
cWhhbmRsZXIoVklSUV9QQ1BVX1NUQVRFLCAwLAorCQkJCSAgICAgIHhlbl9wY3B1X2ludGVycnVw
dCwgMCwKKwkJCQkgICAgICAieGVuLXBjcHUiLCBOVUxMKTsKKwlpZiAoaXJxIDwgMCkgeworCQlw
cl93YXJuaW5nKFhFTl9QQ1BVICJGYWlsZWQgdG8gYmluZCBwY3B1IHZpcnFcbiIpOworCQlyZXR1
cm4gaXJxOworCX0KKworCXJldCA9IHN1YnN5c19zeXN0ZW1fcmVnaXN0ZXIoJnhlbl9wY3B1X3N1
YnN5cywgTlVMTCk7CisJaWYgKHJldCkgeworCQlwcl93YXJuaW5nKFhFTl9QQ1BVICJGYWlsZWQg
dG8gcmVnaXN0ZXIgcGNwdSBzdWJzeXNcbiIpOworCQlnb3RvIGVycjE7CisJfQorCisJcmV0ID0g
eGVuX3N5bmNfcGNwdXMoKTsKKwlpZiAocmV0KSB7CisJCXByX3dhcm5pbmcoWEVOX1BDUFUgIkZh
aWxlZCB0byBzeW5jIHBjcHUgaW5mb1xuIik7CisJCWdvdG8gZXJyMjsKKwl9CisKKwlyZXR1cm4g
MDsKKworZXJyMjoKKwlidXNfdW5yZWdpc3RlcigmeGVuX3BjcHVfc3Vic3lzKTsKK2VycjE6CisJ
dW5iaW5kX2Zyb21faXJxaGFuZGxlcihpcnEsIE5VTEwpOworCXJldHVybiByZXQ7Cit9CithcmNo
X2luaXRjYWxsKHhlbl9wY3B1X2luaXQpOwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS94ZW4vaW50ZXJm
YWNlL3BsYXRmb3JtLmggYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvcGxhdGZvcm0uaAppbmRleCA0
ODY2NTNmLi42MWZhNjYxIDEwMDY0NAotLS0gYS9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvcGxhdGZv
cm0uaAorKysgYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvcGxhdGZvcm0uaApAQCAtMzE0LDYgKzMx
NCwxMyBAQCBzdHJ1Y3QgeGVucGZfcGNwdWluZm8gewogfTsKIERFRklORV9HVUVTVF9IQU5ETEVf
U1RSVUNUKHhlbnBmX3BjcHVpbmZvKTsKIAorI2RlZmluZSBYRU5QRl9jcHVfb25saW5lCTU2Cisj
ZGVmaW5lIFhFTlBGX2NwdV9vZmZsaW5lCTU3CitzdHJ1Y3QgeGVucGZfY3B1X29sIHsKKwl1aW50
MzJfdCBjcHVpZDsKK307CitERUZJTkVfR1VFU1RfSEFORExFX1NUUlVDVCh4ZW5wZl9jcHVfb2wp
OworCiBzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wIHsKIAl1aW50MzJfdCBjbWQ7CiAJdWludDMyX3Qg
aW50ZXJmYWNlX3ZlcnNpb247IC8qIFhFTlBGX0lOVEVSRkFDRV9WRVJTSU9OICovCkBAIC0zMzAs
NiArMzM3LDcgQEAgc3RydWN0IHhlbl9wbGF0Zm9ybV9vcCB7CiAJCXN0cnVjdCB4ZW5wZl9nZXRp
ZGxldGltZSAgICAgICBnZXRpZGxldGltZTsKIAkJc3RydWN0IHhlbnBmX3NldF9wcm9jZXNzb3Jf
cG1pbmZvIHNldF9wbWluZm87CiAJCXN0cnVjdCB4ZW5wZl9wY3B1aW5mbyAgICAgICAgICBwY3B1
X2luZm87CisJCXN0cnVjdCB4ZW5wZl9jcHVfb2wgICAgICAgICAgICBjcHVfb2w7CiAJCXVpbnQ4
X3QgICAgICAgICAgICAgICAgICAgICAgICBwYWRbMTI4XTsKIAl9IHU7CiB9OwpkaWZmIC0tZ2l0
IGEvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3hlbi5oIGIvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3hl
bi5oCmluZGV4IGE4OTA4MDQuLjA4MDE0NjggMTAwNjQ0Ci0tLSBhL2luY2x1ZGUveGVuL2ludGVy
ZmFjZS94ZW4uaAorKysgYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2UveGVuLmgKQEAgLTgwLDYgKzgw
LDcgQEAKICNkZWZpbmUgVklSUV9DT05TT0xFICAgIDIgIC8qIChET00wKSBCeXRlcyByZWNlaXZl
ZCBvbiBlbWVyZ2VuY3kgY29uc29sZS4gKi8KICNkZWZpbmUgVklSUV9ET01fRVhDICAgIDMgIC8q
IChET00wKSBFeGNlcHRpb25hbCBldmVudCBmb3Igc29tZSBkb21haW4uICAgKi8KICNkZWZpbmUg
VklSUV9ERUJVR0dFUiAgIDYgIC8qIChET00wKSBBIGRvbWFpbiBoYXMgcGF1c2VkIGZvciBkZWJ1
Z2dpbmcuICAgKi8KKyNkZWZpbmUgVklSUV9QQ1BVX1NUQVRFIDkgIC8qIChET00wKSBQQ1BVIHN0
YXRlIGNoYW5nZWQgICAgICAgICAgICAgICAgICAgKi8KIAogLyogQXJjaGl0ZWN0dXJlLXNwZWNp
ZmljIFZJUlEgZGVmaW5pdGlvbnMuICovCiAjZGVmaW5lIFZJUlFfQVJDSF8wICAgIDE2Ci0tIAox
LjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC82923351B58A3SHSMSX101ccrcorpi_--
