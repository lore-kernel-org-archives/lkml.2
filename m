Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab2EVJcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:32:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:31448 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757115Ab2EVJcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:32:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="146169354"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] Xen physical cpus online/offline sys interface (v2)
Thread-Topic: [PATCH 3/3] Xen physical cpus online/offline sys interface (v2)
Thread-Index: Ac03/bwan9cpwnVbQ7eTLuUaOhZRDw==
Date: Tue, 22 May 2012 09:31:59 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351D7001@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923351D7001SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923351D7001SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From ad2b459545bda8cc85fd7baf728546f7b6a49252 Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Wed, 23 May 2012 01:16:49 +0800
Subject: [PATCH 3/3] Xen physical cpus online/offline sys interface

This patch provide Xen physical cpus online/offline sys interface.
User can use it for their own purpose, like power saving:
by offlining some cpus when light workload it save power greatly.

Its basic workflow is, user online/offline cpu via sys interface,
then hypercall xen to implement, after done xen inject virq back to dom0,
and then dom0 sync cpu status.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
---
 .../ABI/testing/sysfs-devices-system-xen_cpu       |   20 +
 drivers/xen/Makefile                               |    1 +
 drivers/xen/pcpu.c                                 |  371 ++++++++++++++++=
++++
 include/xen/interface/platform.h                   |    8 +
 include/xen/interface/xen.h                        |    1 +
 5 files changed, 401 insertions(+), 0 deletions(-)
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
index 0000000..067fcfa
--- /dev/null
+++ b/drivers/xen/pcpu.c
@@ -0,0 +1,371 @@
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
+	struct pcpu *pcpu;
+
+	list_for_each_entry(pcpu, &xen_pcpus, list) {
+		if (pcpu->cpu_id =3D=3D cpu_id)
+			return pcpu;
+	}
+
+	return NULL;
+}
+
+static void pcpu_release(struct device *dev)
+{
+	struct pcpu *pcpu =3D container_of(dev, struct pcpu, dev);
+
+	list_del(&pcpu->list);
+	kfree(pcpu);
+}
+
+static void unregister_and_remove_pcpu(struct pcpu *pcpu)
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
+	/* pcpu remove would be implicitly done */
+	device_unregister(dev);
+}
+
+static int register_pcpu(struct pcpu *pcpu)
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
+	dev->release =3D pcpu_release;
+
+	err =3D device_register(dev);
+	if (err) {
+		pcpu_release(dev);
+		return err;
+	}
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
+static struct pcpu *create_and_register_pcpu(struct xenpf_pcpuinfo *info)
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
+	/* Need hold on xen_pcpu_lock before pcpu list manipulations */
+	list_add_tail(&pcpu->list, &xen_pcpus);
+
+	err =3D register_pcpu(pcpu);
+	if (err) {
+		pr_warning(XEN_PCPU "Failed to register pcpu%u\n",
+			   info->xen_cpuid);
+		return ERR_PTR(-ENOENT);
+	}
+
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
+	/*
+	 * Only those at cpu present map has its sys interface.
+	 */
+	if (info->flags & XEN_PCPU_FLAGS_INVALID) {
+		if (pcpu)
+			unregister_and_remove_pcpu(pcpu);
+		return 0;
+	}
+
+	if (!pcpu) {
+		pcpu =3D create_and_register_pcpu(info);
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
+	struct pcpu *pcpu, *tmp;
+
+	mutex_lock(&xen_pcpu_lock);
+
+	while (!err && (cpu <=3D max_cpu)) {
+		err =3D sync_pcpu(cpu, &max_cpu);
+		cpu++;
+	}
+
+	if (err)
+		list_for_each_entry_safe(pcpu, tmp, &xen_pcpus, list)
+			unregister_and_remove_pcpu(pcpu);
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

--_002_DE8DF0795D48FD4CA783C40EC82923351D7001SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0003-Xen-physical-cpus-online-offline-sys-interface.patch"
Content-Description: 0003-Xen-physical-cpus-online-offline-sys-interface.patch
Content-Disposition: attachment;
	filename="0003-Xen-physical-cpus-online-offline-sys-interface.patch";
	size=12982; creation-date="Tue, 22 May 2012 09:22:57 GMT";
	modification-date="Tue, 22 May 2012 17:17:42 GMT"
Content-Transfer-Encoding: base64

RnJvbSBhZDJiNDU5NTQ1YmRhOGNjODVmZDdiYWY3Mjg1NDZmN2I2YTQ5MjUyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogV2VkLCAyMyBNYXkgMjAxMiAwMToxNjo0OSArMDgwMApTdWJqZWN0OiBbUEFUQ0ggMy8z
XSBYZW4gcGh5c2ljYWwgY3B1cyBvbmxpbmUvb2ZmbGluZSBzeXMgaW50ZXJmYWNlCgpUaGlzIHBh
dGNoIHByb3ZpZGUgWGVuIHBoeXNpY2FsIGNwdXMgb25saW5lL29mZmxpbmUgc3lzIGludGVyZmFj
ZS4KVXNlciBjYW4gdXNlIGl0IGZvciB0aGVpciBvd24gcHVycG9zZSwgbGlrZSBwb3dlciBzYXZp
bmc6CmJ5IG9mZmxpbmluZyBzb21lIGNwdXMgd2hlbiBsaWdodCB3b3JrbG9hZCBpdCBzYXZlIHBv
d2VyIGdyZWF0bHkuCgpJdHMgYmFzaWMgd29ya2Zsb3cgaXMsIHVzZXIgb25saW5lL29mZmxpbmUg
Y3B1IHZpYSBzeXMgaW50ZXJmYWNlLAp0aGVuIGh5cGVyY2FsbCB4ZW4gdG8gaW1wbGVtZW50LCBh
ZnRlciBkb25lIHhlbiBpbmplY3QgdmlycSBiYWNrIHRvIGRvbTAsCmFuZCB0aGVuIGRvbTAgc3lu
YyBjcHUgc3RhdHVzLgoKU2lnbmVkLW9mZi1ieTogTGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBp
bnRlbC5jb20+ClNpZ25lZC1vZmYtYnk6IEppYW5nLCBZdW5ob25nIDx5dW5ob25nLmppYW5nQGlu
dGVsLmNvbT4KLS0tCiAuLi4vQUJJL3Rlc3Rpbmcvc3lzZnMtZGV2aWNlcy1zeXN0ZW0teGVuX2Nw
dSAgICAgICB8ICAgMjAgKwogZHJpdmVycy94ZW4vTWFrZWZpbGUgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAgICAxICsKIGRyaXZlcnMveGVuL3BjcHUuYyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgIDM3MSArKysrKysrKysrKysrKysrKysrKwogaW5jbHVkZS94ZW4v
aW50ZXJmYWNlL3BsYXRmb3JtLmggICAgICAgICAgICAgICAgICAgfCAgICA4ICsKIGluY2x1ZGUv
eGVuL2ludGVyZmFjZS94ZW4uaCAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgMSArCiA1IGZp
bGVzIGNoYW5nZWQsIDQwMSBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQogY3JlYXRlIG1v
ZGUgMTAwNjQ0IERvY3VtZW50YXRpb24vQUJJL3Rlc3Rpbmcvc3lzZnMtZGV2aWNlcy1zeXN0ZW0t
eGVuX2NwdQogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMveGVuL3BjcHUuYwoKZGlmZiAtLWdp
dCBhL0RvY3VtZW50YXRpb24vQUJJL3Rlc3Rpbmcvc3lzZnMtZGV2aWNlcy1zeXN0ZW0teGVuX2Nw
dSBiL0RvY3VtZW50YXRpb24vQUJJL3Rlc3Rpbmcvc3lzZnMtZGV2aWNlcy1zeXN0ZW0teGVuX2Nw
dQpuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwLi45Y2EwMmZiCi0tLSAvZGV2L251
bGwKKysrIGIvRG9jdW1lbnRhdGlvbi9BQkkvdGVzdGluZy9zeXNmcy1kZXZpY2VzLXN5c3RlbS14
ZW5fY3B1CkBAIC0wLDAgKzEsMjAgQEAKK1doYXQ6CQkvc3lzL2RldmljZXMvc3lzdGVtL3hlbl9j
cHUvCitEYXRlOgkJTWF5IDIwMTIKK0NvbnRhY3Q6CUxpdSwgSmluc29uZyA8amluc29uZy5saXVA
aW50ZWwuY29tPgorRGVzY3JpcHRpb246CisJCUEgY29sbGVjdGlvbiBvZiBnbG9iYWwvaW5kaXZp
ZHVhbCBYZW4gcGh5c2ljYWwgY3B1IGF0dHJpYnV0ZXMKKworCQlJbmRpdmlkdWFsIHBoeXNpY2Fs
IGNwdSBhdHRyaWJ1dGVzIGFyZSBjb250YWluZWQgaW4KKwkJc3ViZGlyZWN0b3JpZXMgbmFtZWQg
YnkgdGhlIFhlbidzIGxvZ2ljYWwgY3B1IG51bWJlciwgZS5nLjoKKwkJL3N5cy9kZXZpY2VzL3N5
c3RlbS94ZW5fY3B1L3hlbl9jcHUjLworCisKK1doYXQ6CQkvc3lzL2RldmljZXMvc3lzdGVtL3hl
bl9jcHUveGVuX2NwdSMvb25saW5lCitEYXRlOgkJTWF5IDIwMTIKK0NvbnRhY3Q6CUxpdSwgSmlu
c29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgorRGVzY3JpcHRpb246CisJCUludGVyZmFjZSB0
byBvbmxpbmUvb2ZmbGluZSBYZW4gcGh5c2ljYWwgY3B1cworCisJCVdoZW4gcnVubmluZyB1bmRl
ciBYZW4gcGxhdGZvcm0sIGl0IHByb3ZpZGUgdXNlciBpbnRlcmZhY2UKKwkJdG8gb25saW5lL29m
ZmxpbmUgcGh5c2ljYWwgY3B1cywgZXhjZXB0IGNwdTAgZHVlIHRvIHNldmVyYWwKKwkJbG9naWMg
cmVzdHJpY3Rpb25zIGFuZCBhc3N1bXB0aW9ucy4KZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVuL01h
a2VmaWxlIGIvZHJpdmVycy94ZW4vTWFrZWZpbGUKaW5kZXggMWQzZTc2My4uZDEyZDE0ZCAxMDA2
NDQKLS0tIGEvZHJpdmVycy94ZW4vTWFrZWZpbGUKKysrIGIvZHJpdmVycy94ZW4vTWFrZWZpbGUK
QEAgLTE5LDYgKzE5LDcgQEAgb2JqLSQoQ09ORklHX1hFTl9QVkhWTSkJCQkrPSBwbGF0Zm9ybS1w
Y2kubwogb2JqLSQoQ09ORklHX1hFTl9UTUVNKQkJCSs9IHRtZW0ubwogb2JqLSQoQ09ORklHX1NX
SU9UTEJfWEVOKQkJKz0gc3dpb3RsYi14ZW4ubwogb2JqLSQoQ09ORklHX1hFTl9ET00wKQkJCSs9
IHBjaS5vCitvYmotJChDT05GSUdfWEVOX0RPTTApCQkJKz0gcGNwdS5vCiBvYmotJChDT05GSUdf
WEVOX1BDSURFVl9CQUNLRU5EKQkrPSB4ZW4tcGNpYmFjay8KIG9iai0kKENPTkZJR19YRU5fUFJJ
VkNNRCkJCSs9IHhlbi1wcml2Y21kLm8KIG9iai0kKENPTkZJR19YRU5fQUNQSV9QUk9DRVNTT1Ip
CSs9IHhlbi1hY3BpLXByb2Nlc3Nvci5vCmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi9wY3B1LmMg
Yi9kcml2ZXJzL3hlbi9wY3B1LmMKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4u
MDY3ZmNmYQotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZlcnMveGVuL3BjcHUuYwpAQCAtMCwwICsx
LDM3MSBAQAorLyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgorICogcGNwdS5jCisgKiBNYW5hZ2VtZW50
IHBoeXNpY2FsIGNwdSBpbiBkb20wLCBnZXQgcGNwdSBpbmZvIGFuZCBwcm92aWRlIHN5cyBpbnRl
cmZhY2UKKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTIgSW50ZWwgQ29ycG9yYXRpb24KKyAqIEF1
dGhvcjogTGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+CisgKiBBdXRob3I6IEpp
YW5nLCBZdW5ob25nIDx5dW5ob25nLmppYW5nQGludGVsLmNvbT4KKyAqCisgKiBUaGlzIHByb2dy
YW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yCisgKiBt
b2RpZnkgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5z
ZSB2ZXJzaW9uIDIKKyAqIGFzIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0
aW9uOyBvciwgd2hlbiBkaXN0cmlidXRlZAorICogc2VwYXJhdGVseSBmcm9tIHRoZSBMaW51eCBr
ZXJuZWwgb3IgaW5jb3Jwb3JhdGVkIGludG8gb3RoZXIKKyAqIHNvZnR3YXJlIHBhY2thZ2VzLCBz
dWJqZWN0IHRvIHRoZSBmb2xsb3dpbmcgbGljZW5zZToKKyAqCisgKiBQZXJtaXNzaW9uIGlzIGhl
cmVieSBncmFudGVkLCBmcmVlIG9mIGNoYXJnZSwgdG8gYW55IHBlcnNvbiBvYnRhaW5pbmcgYSBj
b3B5CisgKiBvZiB0aGlzIHNvdXJjZSBmaWxlICh0aGUgIlNvZnR3YXJlIiksIHRvIGRlYWwgaW4g
dGhlIFNvZnR3YXJlIHdpdGhvdXQKKyAqIHJlc3RyaWN0aW9uLCBpbmNsdWRpbmcgd2l0aG91dCBs
aW1pdGF0aW9uIHRoZSByaWdodHMgdG8gdXNlLCBjb3B5LCBtb2RpZnksCisgKiBtZXJnZSwgcHVi
bGlzaCwgZGlzdHJpYnV0ZSwgc3VibGljZW5zZSwgYW5kL29yIHNlbGwgY29waWVzIG9mIHRoZSBT
b2Z0d2FyZSwKKyAqIGFuZCB0byBwZXJtaXQgcGVyc29ucyB0byB3aG9tIHRoZSBTb2Z0d2FyZSBp
cyBmdXJuaXNoZWQgdG8gZG8gc28sIHN1YmplY3QgdG8KKyAqIHRoZSBmb2xsb3dpbmcgY29uZGl0
aW9uczoKKyAqCisgKiBUaGUgYWJvdmUgY29weXJpZ2h0IG5vdGljZSBhbmQgdGhpcyBwZXJtaXNz
aW9uIG5vdGljZSBzaGFsbCBiZSBpbmNsdWRlZCBpbgorICogYWxsIGNvcGllcyBvciBzdWJzdGFu
dGlhbCBwb3J0aW9ucyBvZiB0aGUgU29mdHdhcmUuCisgKgorICogVEhFIFNPRlRXQVJFIElTIFBS
T1ZJREVEICJBUyBJUyIsIFdJVEhPVVQgV0FSUkFOVFkgT0YgQU5ZIEtJTkQsIEVYUFJFU1MgT1IK
KyAqIElNUExJRUQsIElOQ0xVRElORyBCVVQgTk9UIExJTUlURUQgVE8gVEhFIFdBUlJBTlRJRVMg
T0YgTUVSQ0hBTlRBQklMSVRZLAorICogRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0Ug
QU5EIE5PTklORlJJTkdFTUVOVC4gSU4gTk8gRVZFTlQgU0hBTEwgVEhFCisgKiBBVVRIT1JTIE9S
IENPUFlSSUdIVCBIT0xERVJTIEJFIExJQUJMRSBGT1IgQU5ZIENMQUlNLCBEQU1BR0VTIE9SIE9U
SEVSCisgKiBMSUFCSUxJVFksIFdIRVRIRVIgSU4gQU4gQUNUSU9OIE9GIENPTlRSQUNULCBUT1JU
IE9SIE9USEVSV0lTRSwgQVJJU0lORworICogRlJPTSwgT1VUIE9GIE9SIElOIENPTk5FQ1RJT04g
V0lUSCBUSEUgU09GVFdBUkUgT1IgVEhFIFVTRSBPUiBPVEhFUiBERUFMSU5HUworICogSU4gVEhF
IFNPRlRXQVJFLgorICovCisKKyNpbmNsdWRlIDxsaW51eC9pbnRlcnJ1cHQuaD4KKyNpbmNsdWRl
IDxsaW51eC9zcGlubG9jay5oPgorI2luY2x1ZGUgPGxpbnV4L2NwdS5oPgorI2luY2x1ZGUgPGxp
bnV4L3N0YXQuaD4KKyNpbmNsdWRlIDxsaW51eC9jYXBhYmlsaXR5Lmg+CisKKyNpbmNsdWRlIDx4
ZW4veGVuLmg+CisjaW5jbHVkZSA8eGVuL3hlbmJ1cy5oPgorI2luY2x1ZGUgPHhlbi9ldmVudHMu
aD4KKyNpbmNsdWRlIDx4ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmg+CisjaW5jbHVkZSA8YXNtL3hl
bi9oeXBlcnZpc29yLmg+CisjaW5jbHVkZSA8YXNtL3hlbi9oeXBlcmNhbGwuaD4KKworI2RlZmlu
ZSBYRU5fUENQVSAieGVuX2NwdTogIgorCisvKgorICogQGNwdV9pZDogWGVuIHBoeXNpY2FsIGNw
dSBsb2dpYyBudW1iZXIKKyAqIEBmbGFnczogWGVuIHBoeXNpY2FsIGNwdSBzdGF0dXMgZmxhZwor
ICogLSBYRU5fUENQVV9GTEFHU19PTkxJTkU6IGNwdSBpcyBvbmxpbmUKKyAqIC0gWEVOX1BDUFVf
RkxBR1NfSU5WQUxJRDogY3B1IGlzIG5vdCBwcmVzZW50CisgKi8KK3N0cnVjdCBwY3B1IHsKKwlz
dHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7CisJc3RydWN0IGRldmljZSBkZXY7CisJdWludDMyX3QgY3B1
X2lkOworCXVpbnQzMl90IGZsYWdzOworfTsKKworc3RhdGljIHN0cnVjdCBidXNfdHlwZSB4ZW5f
cGNwdV9zdWJzeXMgPSB7CisJLm5hbWUgPSAieGVuX2NwdSIsCisJLmRldl9uYW1lID0gInhlbl9j
cHUiLAorfTsKKworc3RhdGljIERFRklORV9NVVRFWCh4ZW5fcGNwdV9sb2NrKTsKKworc3RhdGlj
IExJU1RfSEVBRCh4ZW5fcGNwdXMpOworCitzdGF0aWMgaW50IHhlbl9wY3B1X2Rvd24odWludDMy
X3QgY3B1X2lkKQoreworCXN0cnVjdCB4ZW5fcGxhdGZvcm1fb3Agb3AgPSB7CisJCS5jbWQJCQk9
IFhFTlBGX2NwdV9vZmZsaW5lLAorCQkuaW50ZXJmYWNlX3ZlcnNpb24JPSBYRU5QRl9JTlRFUkZB
Q0VfVkVSU0lPTiwKKwkJLnUuY3B1X29sLmNwdWlkCQk9IGNwdV9pZCwKKwl9OworCisJcmV0dXJu
IEhZUEVSVklTT1JfZG9tMF9vcCgmb3ApOworfQorCitzdGF0aWMgaW50IHhlbl9wY3B1X3VwKHVp
bnQzMl90IGNwdV9pZCkKK3sKKwlzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wIG9wID0geworCQkuY21k
CQkJPSBYRU5QRl9jcHVfb25saW5lLAorCQkuaW50ZXJmYWNlX3ZlcnNpb24JPSBYRU5QRl9JTlRF
UkZBQ0VfVkVSU0lPTiwKKwkJLnUuY3B1X29sLmNwdWlkCQk9IGNwdV9pZCwKKwl9OworCisJcmV0
dXJuIEhZUEVSVklTT1JfZG9tMF9vcCgmb3ApOworfQorCitzdGF0aWMgc3NpemVfdCBzaG93X29u
bGluZShzdHJ1Y3QgZGV2aWNlICpkZXYsCisJCQkgICBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAq
YXR0ciwKKwkJCSAgIGNoYXIgKmJ1ZikKK3sKKwlzdHJ1Y3QgcGNwdSAqY3B1ID0gY29udGFpbmVy
X29mKGRldiwgc3RydWN0IHBjcHUsIGRldik7CisKKwlyZXR1cm4gc3ByaW50ZihidWYsICIldVxu
IiwgISEoY3B1LT5mbGFncyAmIFhFTl9QQ1BVX0ZMQUdTX09OTElORSkpOworfQorCitzdGF0aWMg
c3NpemVfdCBfX3JlZiBzdG9yZV9vbmxpbmUoc3RydWN0IGRldmljZSAqZGV2LAorCQkJCSAgc3Ry
dWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsCisJCQkJICBjb25zdCBjaGFyICpidWYsIHNpemVf
dCBjb3VudCkKK3sKKwlzdHJ1Y3QgcGNwdSAqcGNwdSA9IGNvbnRhaW5lcl9vZihkZXYsIHN0cnVj
dCBwY3B1LCBkZXYpOworCXVuc2lnbmVkIGxvbmcgbG9uZyB2YWw7CisJc3NpemVfdCByZXQ7CisK
KwlpZiAoIWNhcGFibGUoQ0FQX1NZU19BRE1JTikpCisJCXJldHVybiAtRVBFUk07CisKKwlpZiAo
a3N0cnRvdWxsKGJ1ZiwgMCwgJnZhbCkgPCAwKQorCQlyZXR1cm4gLUVJTlZBTDsKKworCXN3aXRj
aCAodmFsKSB7CisJY2FzZSAwOgorCQlyZXQgPSB4ZW5fcGNwdV9kb3duKHBjcHUtPmNwdV9pZCk7
CisJCWJyZWFrOworCWNhc2UgMToKKwkJcmV0ID0geGVuX3BjcHVfdXAocGNwdS0+Y3B1X2lkKTsK
KwkJYnJlYWs7CisJZGVmYXVsdDoKKwkJcmV0ID0gLUVJTlZBTDsKKwl9CisKKwlpZiAocmV0ID49
IDApCisJCXJldCA9IGNvdW50OworCXJldHVybiByZXQ7Cit9CitzdGF0aWMgREVWSUNFX0FUVFIo
b25saW5lLCBTX0lSVUdPIHwgU19JV1VTUiwgc2hvd19vbmxpbmUsIHN0b3JlX29ubGluZSk7CisK
K3N0YXRpYyBib29sIHhlbl9wY3B1X29ubGluZSh1aW50MzJfdCBmbGFncykKK3sKKwlyZXR1cm4g
ISEoZmxhZ3MgJiBYRU5fUENQVV9GTEFHU19PTkxJTkUpOworfQorCitzdGF0aWMgdm9pZCBwY3B1
X29ubGluZV9zdGF0dXMoc3RydWN0IHhlbnBmX3BjcHVpbmZvICppbmZvLAorCQkJICAgICAgIHN0
cnVjdCBwY3B1ICpwY3B1KQoreworCWlmICh4ZW5fcGNwdV9vbmxpbmUoaW5mby0+ZmxhZ3MpICYm
CisJICAgIXhlbl9wY3B1X29ubGluZShwY3B1LT5mbGFncykpIHsKKwkJLyogdGhlIHBjcHUgaXMg
b25saW5lZCAqLworCQlwY3B1LT5mbGFncyB8PSBYRU5fUENQVV9GTEFHU19PTkxJTkU7CisJCWtv
YmplY3RfdWV2ZW50KCZwY3B1LT5kZXYua29iaiwgS09CSl9PTkxJTkUpOworCX0gZWxzZSBpZiAo
IXhlbl9wY3B1X29ubGluZShpbmZvLT5mbGFncykgJiYKKwkJICAgIHhlbl9wY3B1X29ubGluZShw
Y3B1LT5mbGFncykpIHsKKwkJLyogVGhlIHBjcHUgaXMgb2ZmbGluZWQgKi8KKwkJcGNwdS0+Zmxh
Z3MgJj0gflhFTl9QQ1BVX0ZMQUdTX09OTElORTsKKwkJa29iamVjdF91ZXZlbnQoJnBjcHUtPmRl
di5rb2JqLCBLT0JKX09GRkxJTkUpOworCX0KK30KKworc3RhdGljIHN0cnVjdCBwY3B1ICpnZXRf
cGNwdSh1aW50MzJfdCBjcHVfaWQpCit7CisJc3RydWN0IHBjcHUgKnBjcHU7CisKKwlsaXN0X2Zv
cl9lYWNoX2VudHJ5KHBjcHUsICZ4ZW5fcGNwdXMsIGxpc3QpIHsKKwkJaWYgKHBjcHUtPmNwdV9p
ZCA9PSBjcHVfaWQpCisJCQlyZXR1cm4gcGNwdTsKKwl9CisKKwlyZXR1cm4gTlVMTDsKK30KKwor
c3RhdGljIHZvaWQgcGNwdV9yZWxlYXNlKHN0cnVjdCBkZXZpY2UgKmRldikKK3sKKwlzdHJ1Y3Qg
cGNwdSAqcGNwdSA9IGNvbnRhaW5lcl9vZihkZXYsIHN0cnVjdCBwY3B1LCBkZXYpOworCisJbGlz
dF9kZWwoJnBjcHUtPmxpc3QpOworCWtmcmVlKHBjcHUpOworfQorCitzdGF0aWMgdm9pZCB1bnJl
Z2lzdGVyX2FuZF9yZW1vdmVfcGNwdShzdHJ1Y3QgcGNwdSAqcGNwdSkKK3sKKwlzdHJ1Y3QgZGV2
aWNlICpkZXY7CisKKwlpZiAoIXBjcHUpCisJCXJldHVybjsKKworCWRldiA9ICZwY3B1LT5kZXY7
CisJaWYgKGRldi0+aWQpCisJCWRldmljZV9yZW1vdmVfZmlsZShkZXYsICZkZXZfYXR0cl9vbmxp
bmUpOworCisJLyogcGNwdSByZW1vdmUgd291bGQgYmUgaW1wbGljaXRseSBkb25lICovCisJZGV2
aWNlX3VucmVnaXN0ZXIoZGV2KTsKK30KKworc3RhdGljIGludCByZWdpc3Rlcl9wY3B1KHN0cnVj
dCBwY3B1ICpwY3B1KQoreworCXN0cnVjdCBkZXZpY2UgKmRldjsKKwlpbnQgZXJyID0gLUVJTlZB
TDsKKworCWlmICghcGNwdSkKKwkJcmV0dXJuIGVycjsKKworCWRldiA9ICZwY3B1LT5kZXY7CisJ
ZGV2LT5idXMgPSAmeGVuX3BjcHVfc3Vic3lzOworCWRldi0+aWQgPSBwY3B1LT5jcHVfaWQ7CisJ
ZGV2LT5yZWxlYXNlID0gcGNwdV9yZWxlYXNlOworCisJZXJyID0gZGV2aWNlX3JlZ2lzdGVyKGRl
dik7CisJaWYgKGVycikgeworCQlwY3B1X3JlbGVhc2UoZGV2KTsKKwkJcmV0dXJuIGVycjsKKwl9
CisKKwkvKgorCSAqIFhlbiBuZXZlciBvZmZsaW5lIGNwdTAgZHVlIHRvIHNldmVyYWwgcmVzdHJp
Y3Rpb25zCisJICogYW5kIGFzc3VtcHRpb25zLiBUaGlzIGJhc2ljYWxseSBkb2Vzbid0IGFkZCBh
IHN5cyBjb250cm9sCisJICogdG8gdXNlciwgb25lIGNhbm5vdCBhdHRlbXB0IHRvIG9mZmxpbmUg
QlNQLgorCSAqLworCWlmIChkZXYtPmlkKSB7CisJCWVyciA9IGRldmljZV9jcmVhdGVfZmlsZShk
ZXYsICZkZXZfYXR0cl9vbmxpbmUpOworCQlpZiAoZXJyKSB7CisJCQlkZXZpY2VfdW5yZWdpc3Rl
cihkZXYpOworCQkJcmV0dXJuIGVycjsKKwkJfQorCX0KKworCXJldHVybiAwOworfQorCitzdGF0
aWMgc3RydWN0IHBjcHUgKmNyZWF0ZV9hbmRfcmVnaXN0ZXJfcGNwdShzdHJ1Y3QgeGVucGZfcGNw
dWluZm8gKmluZm8pCit7CisJc3RydWN0IHBjcHUgKnBjcHU7CisJaW50IGVycjsKKworCWlmIChp
bmZvLT5mbGFncyAmIFhFTl9QQ1BVX0ZMQUdTX0lOVkFMSUQpCisJCXJldHVybiBFUlJfUFRSKC1F
Tk9ERVYpOworCisJcGNwdSA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBwY3B1KSwgR0ZQX0tFUk5F
TCk7CisJaWYgKCFwY3B1KQorCQlyZXR1cm4gRVJSX1BUUigtRU5PTUVNKTsKKworCUlOSVRfTElT
VF9IRUFEKCZwY3B1LT5saXN0KTsKKwlwY3B1LT5jcHVfaWQgPSBpbmZvLT54ZW5fY3B1aWQ7CisJ
cGNwdS0+ZmxhZ3MgPSBpbmZvLT5mbGFnczsKKworCS8qIE5lZWQgaG9sZCBvbiB4ZW5fcGNwdV9s
b2NrIGJlZm9yZSBwY3B1IGxpc3QgbWFuaXB1bGF0aW9ucyAqLworCWxpc3RfYWRkX3RhaWwoJnBj
cHUtPmxpc3QsICZ4ZW5fcGNwdXMpOworCisJZXJyID0gcmVnaXN0ZXJfcGNwdShwY3B1KTsKKwlp
ZiAoZXJyKSB7CisJCXByX3dhcm5pbmcoWEVOX1BDUFUgIkZhaWxlZCB0byByZWdpc3RlciBwY3B1
JXVcbiIsCisJCQkgICBpbmZvLT54ZW5fY3B1aWQpOworCQlyZXR1cm4gRVJSX1BUUigtRU5PRU5U
KTsKKwl9CisKKwlyZXR1cm4gcGNwdTsKK30KKworLyoKKyAqIENhbGxlciBzaG91bGQgaG9sZCB0
aGUgeGVuX3BjcHVfbG9jaworICovCitzdGF0aWMgaW50IHN5bmNfcGNwdSh1aW50MzJfdCBjcHUs
IHVpbnQzMl90ICptYXhfY3B1KQoreworCWludCByZXQ7CisJc3RydWN0IHBjcHUgKnBjcHUgPSBO
VUxMOworCXN0cnVjdCB4ZW5wZl9wY3B1aW5mbyAqaW5mbzsKKwlzdHJ1Y3QgeGVuX3BsYXRmb3Jt
X29wIG9wID0geworCQkuY21kICAgICAgICAgICAgICAgICAgID0gWEVOUEZfZ2V0X2NwdWluZm8s
CisJCS5pbnRlcmZhY2VfdmVyc2lvbiAgICAgPSBYRU5QRl9JTlRFUkZBQ0VfVkVSU0lPTiwKKwkJ
LnUucGNwdV9pbmZvLnhlbl9jcHVpZCA9IGNwdSwKKwl9OworCisJcmV0ID0gSFlQRVJWSVNPUl9k
b20wX29wKCZvcCk7CisJaWYgKHJldCkKKwkJcmV0dXJuIHJldDsKKworCWluZm8gPSAmb3AudS5w
Y3B1X2luZm87CisJaWYgKG1heF9jcHUpCisJCSptYXhfY3B1ID0gaW5mby0+bWF4X3ByZXNlbnQ7
CisKKwlwY3B1ID0gZ2V0X3BjcHUoY3B1KTsKKworCS8qCisJICogT25seSB0aG9zZSBhdCBjcHUg
cHJlc2VudCBtYXAgaGFzIGl0cyBzeXMgaW50ZXJmYWNlLgorCSAqLworCWlmIChpbmZvLT5mbGFn
cyAmIFhFTl9QQ1BVX0ZMQUdTX0lOVkFMSUQpIHsKKwkJaWYgKHBjcHUpCisJCQl1bnJlZ2lzdGVy
X2FuZF9yZW1vdmVfcGNwdShwY3B1KTsKKwkJcmV0dXJuIDA7CisJfQorCisJaWYgKCFwY3B1KSB7
CisJCXBjcHUgPSBjcmVhdGVfYW5kX3JlZ2lzdGVyX3BjcHUoaW5mbyk7CisJCWlmIChJU19FUlJf
T1JfTlVMTChwY3B1KSkKKwkJCXJldHVybiAtRU5PREVWOworCX0gZWxzZQorCQlwY3B1X29ubGlu
ZV9zdGF0dXMoaW5mbywgcGNwdSk7CisKKwlyZXR1cm4gMDsKK30KKworLyoKKyAqIFN5bmMgZG9t
MCdzIHBjcHUgaW5mb3JtYXRpb24gd2l0aCB4ZW4gaHlwZXJ2aXNvcidzCisgKi8KK3N0YXRpYyBp
bnQgeGVuX3N5bmNfcGNwdXModm9pZCkKK3sKKwkvKgorCSAqIEJvb3QgY3B1IGFsd2F5cyBoYXZl
IGNwdV9pZCAwIGluIHhlbgorCSAqLworCXVpbnQzMl90IGNwdSA9IDAsIG1heF9jcHUgPSAwOwor
CWludCBlcnIgPSAwOworCXN0cnVjdCBwY3B1ICpwY3B1LCAqdG1wOworCisJbXV0ZXhfbG9jaygm
eGVuX3BjcHVfbG9jayk7CisKKwl3aGlsZSAoIWVyciAmJiAoY3B1IDw9IG1heF9jcHUpKSB7CisJ
CWVyciA9IHN5bmNfcGNwdShjcHUsICZtYXhfY3B1KTsKKwkJY3B1Kys7CisJfQorCisJaWYgKGVy
cikKKwkJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKHBjcHUsIHRtcCwgJnhlbl9wY3B1cywgbGlz
dCkKKwkJCXVucmVnaXN0ZXJfYW5kX3JlbW92ZV9wY3B1KHBjcHUpOworCisJbXV0ZXhfdW5sb2Nr
KCZ4ZW5fcGNwdV9sb2NrKTsKKworCXJldHVybiBlcnI7Cit9CisKK3N0YXRpYyB2b2lkIHhlbl9w
Y3B1X3dvcmtfZm4oc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQoreworCXhlbl9zeW5jX3BjcHVz
KCk7Cit9CitzdGF0aWMgREVDTEFSRV9XT1JLKHhlbl9wY3B1X3dvcmssIHhlbl9wY3B1X3dvcmtf
Zm4pOworCitzdGF0aWMgaXJxcmV0dXJuX3QgeGVuX3BjcHVfaW50ZXJydXB0KGludCBpcnEsIHZv
aWQgKmRldl9pZCkKK3sKKwlzY2hlZHVsZV93b3JrKCZ4ZW5fcGNwdV93b3JrKTsKKwlyZXR1cm4g
SVJRX0hBTkRMRUQ7Cit9CisKK3N0YXRpYyBpbnQgX19pbml0IHhlbl9wY3B1X2luaXQodm9pZCkK
K3sKKwlpbnQgaXJxLCByZXQ7CisKKwlpZiAoIXhlbl9pbml0aWFsX2RvbWFpbigpKQorCQlyZXR1
cm4gLUVOT0RFVjsKKworCWlycSA9IGJpbmRfdmlycV90b19pcnFoYW5kbGVyKFZJUlFfUENQVV9T
VEFURSwgMCwKKwkJCQkgICAgICB4ZW5fcGNwdV9pbnRlcnJ1cHQsIDAsCisJCQkJICAgICAgInhl
bi1wY3B1IiwgTlVMTCk7CisJaWYgKGlycSA8IDApIHsKKwkJcHJfd2FybmluZyhYRU5fUENQVSAi
RmFpbGVkIHRvIGJpbmQgcGNwdSB2aXJxXG4iKTsKKwkJcmV0dXJuIGlycTsKKwl9CisKKwlyZXQg
PSBzdWJzeXNfc3lzdGVtX3JlZ2lzdGVyKCZ4ZW5fcGNwdV9zdWJzeXMsIE5VTEwpOworCWlmIChy
ZXQpIHsKKwkJcHJfd2FybmluZyhYRU5fUENQVSAiRmFpbGVkIHRvIHJlZ2lzdGVyIHBjcHUgc3Vi
c3lzXG4iKTsKKwkJZ290byBlcnIxOworCX0KKworCXJldCA9IHhlbl9zeW5jX3BjcHVzKCk7CisJ
aWYgKHJldCkgeworCQlwcl93YXJuaW5nKFhFTl9QQ1BVICJGYWlsZWQgdG8gc3luYyBwY3B1IGlu
Zm9cbiIpOworCQlnb3RvIGVycjI7CisJfQorCisJcmV0dXJuIDA7CisKK2VycjI6CisJYnVzX3Vu
cmVnaXN0ZXIoJnhlbl9wY3B1X3N1YnN5cyk7CitlcnIxOgorCXVuYmluZF9mcm9tX2lycWhhbmRs
ZXIoaXJxLCBOVUxMKTsKKwlyZXR1cm4gcmV0OworfQorYXJjaF9pbml0Y2FsbCh4ZW5fcGNwdV9p
bml0KTsKZGlmZiAtLWdpdCBhL2luY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oIGIvaW5j
bHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgKaW5kZXggNDg2NjUzZi4uNjFmYTY2MSAxMDA2
NDQKLS0tIGEvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgKKysrIGIvaW5jbHVkZS94
ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgKQEAgLTMxNCw2ICszMTQsMTMgQEAgc3RydWN0IHhlbnBm
X3BjcHVpbmZvIHsKIH07CiBERUZJTkVfR1VFU1RfSEFORExFX1NUUlVDVCh4ZW5wZl9wY3B1aW5m
byk7CiAKKyNkZWZpbmUgWEVOUEZfY3B1X29ubGluZQk1NgorI2RlZmluZSBYRU5QRl9jcHVfb2Zm
bGluZQk1Nworc3RydWN0IHhlbnBmX2NwdV9vbCB7CisJdWludDMyX3QgY3B1aWQ7Cit9OworREVG
SU5FX0dVRVNUX0hBTkRMRV9TVFJVQ1QoeGVucGZfY3B1X29sKTsKKwogc3RydWN0IHhlbl9wbGF0
Zm9ybV9vcCB7CiAJdWludDMyX3QgY21kOwogCXVpbnQzMl90IGludGVyZmFjZV92ZXJzaW9uOyAv
KiBYRU5QRl9JTlRFUkZBQ0VfVkVSU0lPTiAqLwpAQCAtMzMwLDYgKzMzNyw3IEBAIHN0cnVjdCB4
ZW5fcGxhdGZvcm1fb3AgewogCQlzdHJ1Y3QgeGVucGZfZ2V0aWRsZXRpbWUgICAgICAgZ2V0aWRs
ZXRpbWU7CiAJCXN0cnVjdCB4ZW5wZl9zZXRfcHJvY2Vzc29yX3BtaW5mbyBzZXRfcG1pbmZvOwog
CQlzdHJ1Y3QgeGVucGZfcGNwdWluZm8gICAgICAgICAgcGNwdV9pbmZvOworCQlzdHJ1Y3QgeGVu
cGZfY3B1X29sICAgICAgICAgICAgY3B1X29sOwogCQl1aW50OF90ICAgICAgICAgICAgICAgICAg
ICAgICAgcGFkWzEyOF07CiAJfSB1OwogfTsKZGlmZiAtLWdpdCBhL2luY2x1ZGUveGVuL2ludGVy
ZmFjZS94ZW4uaCBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS94ZW4uaAppbmRleCBhODkwODA0Li4w
ODAxNDY4IDEwMDY0NAotLS0gYS9pbmNsdWRlL3hlbi9pbnRlcmZhY2UveGVuLmgKKysrIGIvaW5j
bHVkZS94ZW4vaW50ZXJmYWNlL3hlbi5oCkBAIC04MCw2ICs4MCw3IEBACiAjZGVmaW5lIFZJUlFf
Q09OU09MRSAgICAyICAvKiAoRE9NMCkgQnl0ZXMgcmVjZWl2ZWQgb24gZW1lcmdlbmN5IGNvbnNv
bGUuICovCiAjZGVmaW5lIFZJUlFfRE9NX0VYQyAgICAzICAvKiAoRE9NMCkgRXhjZXB0aW9uYWwg
ZXZlbnQgZm9yIHNvbWUgZG9tYWluLiAgICovCiAjZGVmaW5lIFZJUlFfREVCVUdHRVIgICA2ICAv
KiAoRE9NMCkgQSBkb21haW4gaGFzIHBhdXNlZCBmb3IgZGVidWdnaW5nLiAgICovCisjZGVmaW5l
IFZJUlFfUENQVV9TVEFURSA5ICAvKiAoRE9NMCkgUENQVSBzdGF0ZSBjaGFuZ2VkICAgICAgICAg
ICAgICAgICAgICovCiAKIC8qIEFyY2hpdGVjdHVyZS1zcGVjaWZpYyBWSVJRIGRlZmluaXRpb25z
LiAqLwogI2RlZmluZSBWSVJRX0FSQ0hfMCAgICAxNgotLSAKMS43LjEKCg==

--_002_DE8DF0795D48FD4CA783C40EC82923351D7001SHSMSX101ccrcorpi_--
