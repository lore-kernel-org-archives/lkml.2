Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab2FKF4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 01:56:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:48099 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab2FKF4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 01:56:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="110541021"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Xen physical cpus online/offline sys interface
Thread-Topic: [PATCH] Xen physical cpus online/offline sys interface
Thread-Index: Ac1HlvJigoMtmxewSn6Qfo6O3a56Lw==
Date: Mon, 11 Jun 2012 05:56:29 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923352259E4@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923352259E4SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923352259E4SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Konrad,

Our old patch of cpu online/offline is based on old kernel tree.
I rebase it to your latest xen.git
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git   branch devel=
/mce.v3

Thanks,
Jinsong

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>From 29152bb054d87334ef970ad037888b7bb032f8ef Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Mon, 11 Jun 2012 20:38:08 +0800
Subject: [PATCH] Xen physical cpus online/offline sys interface

This patch provide Xen physical cpus online/offline sys interface.
User can use it for their own purpose, like power saving:
by offlining some cpus when light workload it save power greatly.

Its basic workflow is, user online/offline cpu via sys interface,
then hypercall xen to implement, after done xen inject virq back to dom0,
and then dom0 sync cpu status.

Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
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
index a787029..d80bea5 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+=3D sys-hypervisor.o
 obj-$(CONFIG_XEN_PVHVM)			+=3D platform-pci.o
 obj-$(CONFIG_XEN_TMEM)			+=3D tmem.o
 obj-$(CONFIG_SWIOTLB_XEN)		+=3D swiotlb-xen.o
+obj-$(CONFIG_XEN_DOM0)			+=3D pcpu.o
 obj-$(CONFIG_XEN_DOM0)			+=3D pci.o acpi.o
 obj-$(CONFIG_XEN_MCE_LOG)		+=3D mcelog.o
 obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+=3D xen-pciback/
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

--_002_DE8DF0795D48FD4CA783C40EC82923352259E4SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-Xen-physical-cpus-online-offline-sys-interface.patch"
Content-Description: 0001-Xen-physical-cpus-online-offline-sys-interface.patch
Content-Disposition: attachment;
	filename="0001-Xen-physical-cpus-online-offline-sys-interface.patch";
	size=12976; creation-date="Mon, 11 Jun 2012 05:50:08 GMT";
	modification-date="Mon, 11 Jun 2012 13:44:12 GMT"
Content-Transfer-Encoding: base64

RnJvbSAyOTE1MmJiMDU0ZDg3MzM0ZWY5NzBhZDAzNzg4OGI3YmIwMzJmOGVmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogTW9uLCAxMSBKdW4gMjAxMiAyMDozODowOCArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIFhl
biBwaHlzaWNhbCBjcHVzIG9ubGluZS9vZmZsaW5lIHN5cyBpbnRlcmZhY2UKClRoaXMgcGF0Y2gg
cHJvdmlkZSBYZW4gcGh5c2ljYWwgY3B1cyBvbmxpbmUvb2ZmbGluZSBzeXMgaW50ZXJmYWNlLgpV
c2VyIGNhbiB1c2UgaXQgZm9yIHRoZWlyIG93biBwdXJwb3NlLCBsaWtlIHBvd2VyIHNhdmluZzoK
Ynkgb2ZmbGluaW5nIHNvbWUgY3B1cyB3aGVuIGxpZ2h0IHdvcmtsb2FkIGl0IHNhdmUgcG93ZXIg
Z3JlYXRseS4KCkl0cyBiYXNpYyB3b3JrZmxvdyBpcywgdXNlciBvbmxpbmUvb2ZmbGluZSBjcHUg
dmlhIHN5cyBpbnRlcmZhY2UsCnRoZW4gaHlwZXJjYWxsIHhlbiB0byBpbXBsZW1lbnQsIGFmdGVy
IGRvbmUgeGVuIGluamVjdCB2aXJxIGJhY2sgdG8gZG9tMCwKYW5kIHRoZW4gZG9tMCBzeW5jIGNw
dSBzdGF0dXMuCgpTaWduZWQtb2ZmLWJ5OiBKaWFuZywgWXVuaG9uZyA8eXVuaG9uZy5qaWFuZ0Bp
bnRlbC5jb20+ClNpZ25lZC1vZmYtYnk6IExpdSwgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwu
Y29tPgotLS0KIC4uLi9BQkkvdGVzdGluZy9zeXNmcy1kZXZpY2VzLXN5c3RlbS14ZW5fY3B1ICAg
ICAgIHwgICAyMCArCiBkcml2ZXJzL3hlbi9NYWtlZmlsZSAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB8ICAgIDEgKwogZHJpdmVycy94ZW4vcGNwdS5jICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAgMzcxICsrKysrKysrKysrKysrKysrKysrCiBpbmNsdWRlL3hlbi9pbnRl
cmZhY2UvcGxhdGZvcm0uaCAgICAgICAgICAgICAgICAgICB8ICAgIDggKwogaW5jbHVkZS94ZW4v
aW50ZXJmYWNlL3hlbi5oICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAxICsKIDUgZmlsZXMg
Y2hhbmdlZCwgNDAxIGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCiBjcmVhdGUgbW9kZSAx
MDA2NDQgRG9jdW1lbnRhdGlvbi9BQkkvdGVzdGluZy9zeXNmcy1kZXZpY2VzLXN5c3RlbS14ZW5f
Y3B1CiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy94ZW4vcGNwdS5jCgpkaWZmIC0tZ2l0IGEv
RG9jdW1lbnRhdGlvbi9BQkkvdGVzdGluZy9zeXNmcy1kZXZpY2VzLXN5c3RlbS14ZW5fY3B1IGIv
RG9jdW1lbnRhdGlvbi9BQkkvdGVzdGluZy9zeXNmcy1kZXZpY2VzLXN5c3RlbS14ZW5fY3B1Cm5l
dyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLjljYTAyZmIKLS0tIC9kZXYvbnVsbAor
KysgYi9Eb2N1bWVudGF0aW9uL0FCSS90ZXN0aW5nL3N5c2ZzLWRldmljZXMtc3lzdGVtLXhlbl9j
cHUKQEAgLTAsMCArMSwyMCBAQAorV2hhdDoJCS9zeXMvZGV2aWNlcy9zeXN0ZW0veGVuX2NwdS8K
K0RhdGU6CQlNYXkgMjAxMgorQ29udGFjdDoJTGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRl
bC5jb20+CitEZXNjcmlwdGlvbjoKKwkJQSBjb2xsZWN0aW9uIG9mIGdsb2JhbC9pbmRpdmlkdWFs
IFhlbiBwaHlzaWNhbCBjcHUgYXR0cmlidXRlcworCisJCUluZGl2aWR1YWwgcGh5c2ljYWwgY3B1
IGF0dHJpYnV0ZXMgYXJlIGNvbnRhaW5lZCBpbgorCQlzdWJkaXJlY3RvcmllcyBuYW1lZCBieSB0
aGUgWGVuJ3MgbG9naWNhbCBjcHUgbnVtYmVyLCBlLmcuOgorCQkvc3lzL2RldmljZXMvc3lzdGVt
L3hlbl9jcHUveGVuX2NwdSMvCisKKworV2hhdDoJCS9zeXMvZGV2aWNlcy9zeXN0ZW0veGVuX2Nw
dS94ZW5fY3B1Iy9vbmxpbmUKK0RhdGU6CQlNYXkgMjAxMgorQ29udGFjdDoJTGl1LCBKaW5zb25n
IDxqaW5zb25nLmxpdUBpbnRlbC5jb20+CitEZXNjcmlwdGlvbjoKKwkJSW50ZXJmYWNlIHRvIG9u
bGluZS9vZmZsaW5lIFhlbiBwaHlzaWNhbCBjcHVzCisKKwkJV2hlbiBydW5uaW5nIHVuZGVyIFhl
biBwbGF0Zm9ybSwgaXQgcHJvdmlkZSB1c2VyIGludGVyZmFjZQorCQl0byBvbmxpbmUvb2ZmbGlu
ZSBwaHlzaWNhbCBjcHVzLCBleGNlcHQgY3B1MCBkdWUgdG8gc2V2ZXJhbAorCQlsb2dpYyByZXN0
cmljdGlvbnMgYW5kIGFzc3VtcHRpb25zLgpkaWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4vTWFrZWZp
bGUgYi9kcml2ZXJzL3hlbi9NYWtlZmlsZQppbmRleCBhNzg3MDI5Li5kODBiZWE1IDEwMDY0NAot
LS0gYS9kcml2ZXJzL3hlbi9NYWtlZmlsZQorKysgYi9kcml2ZXJzL3hlbi9NYWtlZmlsZQpAQCAt
MTcsNiArMTcsNyBAQCBvYmotJChDT05GSUdfWEVOX1NZU19IWVBFUlZJU09SKQkrPSBzeXMtaHlw
ZXJ2aXNvci5vCiBvYmotJChDT05GSUdfWEVOX1BWSFZNKQkJCSs9IHBsYXRmb3JtLXBjaS5vCiBv
YmotJChDT05GSUdfWEVOX1RNRU0pCQkJKz0gdG1lbS5vCiBvYmotJChDT05GSUdfU1dJT1RMQl9Y
RU4pCQkrPSBzd2lvdGxiLXhlbi5vCitvYmotJChDT05GSUdfWEVOX0RPTTApCQkJKz0gcGNwdS5v
CiBvYmotJChDT05GSUdfWEVOX0RPTTApCQkJKz0gcGNpLm8gYWNwaS5vCiBvYmotJChDT05GSUdf
WEVOX01DRV9MT0cpCQkrPSBtY2Vsb2cubwogb2JqLSQoQ09ORklHX1hFTl9QQ0lERVZfQkFDS0VO
RCkJKz0geGVuLXBjaWJhY2svCmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi9wY3B1LmMgYi9kcml2
ZXJzL3hlbi9wY3B1LmMKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uMDY3ZmNm
YQotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZlcnMveGVuL3BjcHUuYwpAQCAtMCwwICsxLDM3MSBA
QAorLyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKgorICogcGNwdS5jCisgKiBNYW5hZ2VtZW50IHBoeXNp
Y2FsIGNwdSBpbiBkb20wLCBnZXQgcGNwdSBpbmZvIGFuZCBwcm92aWRlIHN5cyBpbnRlcmZhY2UK
KyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTIgSW50ZWwgQ29ycG9yYXRpb24KKyAqIEF1dGhvcjog
TGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+CisgKiBBdXRob3I6IEppYW5nLCBZ
dW5ob25nIDx5dW5ob25nLmppYW5nQGludGVsLmNvbT4KKyAqCisgKiBUaGlzIHByb2dyYW0gaXMg
ZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yCisgKiBtb2RpZnkg
aXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSB2ZXJz
aW9uIDIKKyAqIGFzIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBv
ciwgd2hlbiBkaXN0cmlidXRlZAorICogc2VwYXJhdGVseSBmcm9tIHRoZSBMaW51eCBrZXJuZWwg
b3IgaW5jb3Jwb3JhdGVkIGludG8gb3RoZXIKKyAqIHNvZnR3YXJlIHBhY2thZ2VzLCBzdWJqZWN0
IHRvIHRoZSBmb2xsb3dpbmcgbGljZW5zZToKKyAqCisgKiBQZXJtaXNzaW9uIGlzIGhlcmVieSBn
cmFudGVkLCBmcmVlIG9mIGNoYXJnZSwgdG8gYW55IHBlcnNvbiBvYnRhaW5pbmcgYSBjb3B5Cisg
KiBvZiB0aGlzIHNvdXJjZSBmaWxlICh0aGUgIlNvZnR3YXJlIiksIHRvIGRlYWwgaW4gdGhlIFNv
ZnR3YXJlIHdpdGhvdXQKKyAqIHJlc3RyaWN0aW9uLCBpbmNsdWRpbmcgd2l0aG91dCBsaW1pdGF0
aW9uIHRoZSByaWdodHMgdG8gdXNlLCBjb3B5LCBtb2RpZnksCisgKiBtZXJnZSwgcHVibGlzaCwg
ZGlzdHJpYnV0ZSwgc3VibGljZW5zZSwgYW5kL29yIHNlbGwgY29waWVzIG9mIHRoZSBTb2Z0d2Fy
ZSwKKyAqIGFuZCB0byBwZXJtaXQgcGVyc29ucyB0byB3aG9tIHRoZSBTb2Z0d2FyZSBpcyBmdXJu
aXNoZWQgdG8gZG8gc28sIHN1YmplY3QgdG8KKyAqIHRoZSBmb2xsb3dpbmcgY29uZGl0aW9uczoK
KyAqCisgKiBUaGUgYWJvdmUgY29weXJpZ2h0IG5vdGljZSBhbmQgdGhpcyBwZXJtaXNzaW9uIG5v
dGljZSBzaGFsbCBiZSBpbmNsdWRlZCBpbgorICogYWxsIGNvcGllcyBvciBzdWJzdGFudGlhbCBw
b3J0aW9ucyBvZiB0aGUgU29mdHdhcmUuCisgKgorICogVEhFIFNPRlRXQVJFIElTIFBST1ZJREVE
ICJBUyBJUyIsIFdJVEhPVVQgV0FSUkFOVFkgT0YgQU5ZIEtJTkQsIEVYUFJFU1MgT1IKKyAqIElN
UExJRUQsIElOQ0xVRElORyBCVVQgTk9UIExJTUlURUQgVE8gVEhFIFdBUlJBTlRJRVMgT0YgTUVS
Q0hBTlRBQklMSVRZLAorICogRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UgQU5EIE5P
TklORlJJTkdFTUVOVC4gSU4gTk8gRVZFTlQgU0hBTEwgVEhFCisgKiBBVVRIT1JTIE9SIENPUFlS
SUdIVCBIT0xERVJTIEJFIExJQUJMRSBGT1IgQU5ZIENMQUlNLCBEQU1BR0VTIE9SIE9USEVSCisg
KiBMSUFCSUxJVFksIFdIRVRIRVIgSU4gQU4gQUNUSU9OIE9GIENPTlRSQUNULCBUT1JUIE9SIE9U
SEVSV0lTRSwgQVJJU0lORworICogRlJPTSwgT1VUIE9GIE9SIElOIENPTk5FQ1RJT04gV0lUSCBU
SEUgU09GVFdBUkUgT1IgVEhFIFVTRSBPUiBPVEhFUiBERUFMSU5HUworICogSU4gVEhFIFNPRlRX
QVJFLgorICovCisKKyNpbmNsdWRlIDxsaW51eC9pbnRlcnJ1cHQuaD4KKyNpbmNsdWRlIDxsaW51
eC9zcGlubG9jay5oPgorI2luY2x1ZGUgPGxpbnV4L2NwdS5oPgorI2luY2x1ZGUgPGxpbnV4L3N0
YXQuaD4KKyNpbmNsdWRlIDxsaW51eC9jYXBhYmlsaXR5Lmg+CisKKyNpbmNsdWRlIDx4ZW4veGVu
Lmg+CisjaW5jbHVkZSA8eGVuL3hlbmJ1cy5oPgorI2luY2x1ZGUgPHhlbi9ldmVudHMuaD4KKyNp
bmNsdWRlIDx4ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmg+CisjaW5jbHVkZSA8YXNtL3hlbi9oeXBl
cnZpc29yLmg+CisjaW5jbHVkZSA8YXNtL3hlbi9oeXBlcmNhbGwuaD4KKworI2RlZmluZSBYRU5f
UENQVSAieGVuX2NwdTogIgorCisvKgorICogQGNwdV9pZDogWGVuIHBoeXNpY2FsIGNwdSBsb2dp
YyBudW1iZXIKKyAqIEBmbGFnczogWGVuIHBoeXNpY2FsIGNwdSBzdGF0dXMgZmxhZworICogLSBY
RU5fUENQVV9GTEFHU19PTkxJTkU6IGNwdSBpcyBvbmxpbmUKKyAqIC0gWEVOX1BDUFVfRkxBR1Nf
SU5WQUxJRDogY3B1IGlzIG5vdCBwcmVzZW50CisgKi8KK3N0cnVjdCBwY3B1IHsKKwlzdHJ1Y3Qg
bGlzdF9oZWFkIGxpc3Q7CisJc3RydWN0IGRldmljZSBkZXY7CisJdWludDMyX3QgY3B1X2lkOwor
CXVpbnQzMl90IGZsYWdzOworfTsKKworc3RhdGljIHN0cnVjdCBidXNfdHlwZSB4ZW5fcGNwdV9z
dWJzeXMgPSB7CisJLm5hbWUgPSAieGVuX2NwdSIsCisJLmRldl9uYW1lID0gInhlbl9jcHUiLAor
fTsKKworc3RhdGljIERFRklORV9NVVRFWCh4ZW5fcGNwdV9sb2NrKTsKKworc3RhdGljIExJU1Rf
SEVBRCh4ZW5fcGNwdXMpOworCitzdGF0aWMgaW50IHhlbl9wY3B1X2Rvd24odWludDMyX3QgY3B1
X2lkKQoreworCXN0cnVjdCB4ZW5fcGxhdGZvcm1fb3Agb3AgPSB7CisJCS5jbWQJCQk9IFhFTlBG
X2NwdV9vZmZsaW5lLAorCQkuaW50ZXJmYWNlX3ZlcnNpb24JPSBYRU5QRl9JTlRFUkZBQ0VfVkVS
U0lPTiwKKwkJLnUuY3B1X29sLmNwdWlkCQk9IGNwdV9pZCwKKwl9OworCisJcmV0dXJuIEhZUEVS
VklTT1JfZG9tMF9vcCgmb3ApOworfQorCitzdGF0aWMgaW50IHhlbl9wY3B1X3VwKHVpbnQzMl90
IGNwdV9pZCkKK3sKKwlzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wIG9wID0geworCQkuY21kCQkJPSBY
RU5QRl9jcHVfb25saW5lLAorCQkuaW50ZXJmYWNlX3ZlcnNpb24JPSBYRU5QRl9JTlRFUkZBQ0Vf
VkVSU0lPTiwKKwkJLnUuY3B1X29sLmNwdWlkCQk9IGNwdV9pZCwKKwl9OworCisJcmV0dXJuIEhZ
UEVSVklTT1JfZG9tMF9vcCgmb3ApOworfQorCitzdGF0aWMgc3NpemVfdCBzaG93X29ubGluZShz
dHJ1Y3QgZGV2aWNlICpkZXYsCisJCQkgICBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwK
KwkJCSAgIGNoYXIgKmJ1ZikKK3sKKwlzdHJ1Y3QgcGNwdSAqY3B1ID0gY29udGFpbmVyX29mKGRl
diwgc3RydWN0IHBjcHUsIGRldik7CisKKwlyZXR1cm4gc3ByaW50ZihidWYsICIldVxuIiwgISEo
Y3B1LT5mbGFncyAmIFhFTl9QQ1BVX0ZMQUdTX09OTElORSkpOworfQorCitzdGF0aWMgc3NpemVf
dCBfX3JlZiBzdG9yZV9vbmxpbmUoc3RydWN0IGRldmljZSAqZGV2LAorCQkJCSAgc3RydWN0IGRl
dmljZV9hdHRyaWJ1dGUgKmF0dHIsCisJCQkJICBjb25zdCBjaGFyICpidWYsIHNpemVfdCBjb3Vu
dCkKK3sKKwlzdHJ1Y3QgcGNwdSAqcGNwdSA9IGNvbnRhaW5lcl9vZihkZXYsIHN0cnVjdCBwY3B1
LCBkZXYpOworCXVuc2lnbmVkIGxvbmcgbG9uZyB2YWw7CisJc3NpemVfdCByZXQ7CisKKwlpZiAo
IWNhcGFibGUoQ0FQX1NZU19BRE1JTikpCisJCXJldHVybiAtRVBFUk07CisKKwlpZiAoa3N0cnRv
dWxsKGJ1ZiwgMCwgJnZhbCkgPCAwKQorCQlyZXR1cm4gLUVJTlZBTDsKKworCXN3aXRjaCAodmFs
KSB7CisJY2FzZSAwOgorCQlyZXQgPSB4ZW5fcGNwdV9kb3duKHBjcHUtPmNwdV9pZCk7CisJCWJy
ZWFrOworCWNhc2UgMToKKwkJcmV0ID0geGVuX3BjcHVfdXAocGNwdS0+Y3B1X2lkKTsKKwkJYnJl
YWs7CisJZGVmYXVsdDoKKwkJcmV0ID0gLUVJTlZBTDsKKwl9CisKKwlpZiAocmV0ID49IDApCisJ
CXJldCA9IGNvdW50OworCXJldHVybiByZXQ7Cit9CitzdGF0aWMgREVWSUNFX0FUVFIob25saW5l
LCBTX0lSVUdPIHwgU19JV1VTUiwgc2hvd19vbmxpbmUsIHN0b3JlX29ubGluZSk7CisKK3N0YXRp
YyBib29sIHhlbl9wY3B1X29ubGluZSh1aW50MzJfdCBmbGFncykKK3sKKwlyZXR1cm4gISEoZmxh
Z3MgJiBYRU5fUENQVV9GTEFHU19PTkxJTkUpOworfQorCitzdGF0aWMgdm9pZCBwY3B1X29ubGlu
ZV9zdGF0dXMoc3RydWN0IHhlbnBmX3BjcHVpbmZvICppbmZvLAorCQkJICAgICAgIHN0cnVjdCBw
Y3B1ICpwY3B1KQoreworCWlmICh4ZW5fcGNwdV9vbmxpbmUoaW5mby0+ZmxhZ3MpICYmCisJICAg
IXhlbl9wY3B1X29ubGluZShwY3B1LT5mbGFncykpIHsKKwkJLyogdGhlIHBjcHUgaXMgb25saW5l
ZCAqLworCQlwY3B1LT5mbGFncyB8PSBYRU5fUENQVV9GTEFHU19PTkxJTkU7CisJCWtvYmplY3Rf
dWV2ZW50KCZwY3B1LT5kZXYua29iaiwgS09CSl9PTkxJTkUpOworCX0gZWxzZSBpZiAoIXhlbl9w
Y3B1X29ubGluZShpbmZvLT5mbGFncykgJiYKKwkJICAgIHhlbl9wY3B1X29ubGluZShwY3B1LT5m
bGFncykpIHsKKwkJLyogVGhlIHBjcHUgaXMgb2ZmbGluZWQgKi8KKwkJcGNwdS0+ZmxhZ3MgJj0g
flhFTl9QQ1BVX0ZMQUdTX09OTElORTsKKwkJa29iamVjdF91ZXZlbnQoJnBjcHUtPmRldi5rb2Jq
LCBLT0JKX09GRkxJTkUpOworCX0KK30KKworc3RhdGljIHN0cnVjdCBwY3B1ICpnZXRfcGNwdSh1
aW50MzJfdCBjcHVfaWQpCit7CisJc3RydWN0IHBjcHUgKnBjcHU7CisKKwlsaXN0X2Zvcl9lYWNo
X2VudHJ5KHBjcHUsICZ4ZW5fcGNwdXMsIGxpc3QpIHsKKwkJaWYgKHBjcHUtPmNwdV9pZCA9PSBj
cHVfaWQpCisJCQlyZXR1cm4gcGNwdTsKKwl9CisKKwlyZXR1cm4gTlVMTDsKK30KKworc3RhdGlj
IHZvaWQgcGNwdV9yZWxlYXNlKHN0cnVjdCBkZXZpY2UgKmRldikKK3sKKwlzdHJ1Y3QgcGNwdSAq
cGNwdSA9IGNvbnRhaW5lcl9vZihkZXYsIHN0cnVjdCBwY3B1LCBkZXYpOworCisJbGlzdF9kZWwo
JnBjcHUtPmxpc3QpOworCWtmcmVlKHBjcHUpOworfQorCitzdGF0aWMgdm9pZCB1bnJlZ2lzdGVy
X2FuZF9yZW1vdmVfcGNwdShzdHJ1Y3QgcGNwdSAqcGNwdSkKK3sKKwlzdHJ1Y3QgZGV2aWNlICpk
ZXY7CisKKwlpZiAoIXBjcHUpCisJCXJldHVybjsKKworCWRldiA9ICZwY3B1LT5kZXY7CisJaWYg
KGRldi0+aWQpCisJCWRldmljZV9yZW1vdmVfZmlsZShkZXYsICZkZXZfYXR0cl9vbmxpbmUpOwor
CisJLyogcGNwdSByZW1vdmUgd291bGQgYmUgaW1wbGljaXRseSBkb25lICovCisJZGV2aWNlX3Vu
cmVnaXN0ZXIoZGV2KTsKK30KKworc3RhdGljIGludCByZWdpc3Rlcl9wY3B1KHN0cnVjdCBwY3B1
ICpwY3B1KQoreworCXN0cnVjdCBkZXZpY2UgKmRldjsKKwlpbnQgZXJyID0gLUVJTlZBTDsKKwor
CWlmICghcGNwdSkKKwkJcmV0dXJuIGVycjsKKworCWRldiA9ICZwY3B1LT5kZXY7CisJZGV2LT5i
dXMgPSAmeGVuX3BjcHVfc3Vic3lzOworCWRldi0+aWQgPSBwY3B1LT5jcHVfaWQ7CisJZGV2LT5y
ZWxlYXNlID0gcGNwdV9yZWxlYXNlOworCisJZXJyID0gZGV2aWNlX3JlZ2lzdGVyKGRldik7CisJ
aWYgKGVycikgeworCQlwY3B1X3JlbGVhc2UoZGV2KTsKKwkJcmV0dXJuIGVycjsKKwl9CisKKwkv
KgorCSAqIFhlbiBuZXZlciBvZmZsaW5lIGNwdTAgZHVlIHRvIHNldmVyYWwgcmVzdHJpY3Rpb25z
CisJICogYW5kIGFzc3VtcHRpb25zLiBUaGlzIGJhc2ljYWxseSBkb2Vzbid0IGFkZCBhIHN5cyBj
b250cm9sCisJICogdG8gdXNlciwgb25lIGNhbm5vdCBhdHRlbXB0IHRvIG9mZmxpbmUgQlNQLgor
CSAqLworCWlmIChkZXYtPmlkKSB7CisJCWVyciA9IGRldmljZV9jcmVhdGVfZmlsZShkZXYsICZk
ZXZfYXR0cl9vbmxpbmUpOworCQlpZiAoZXJyKSB7CisJCQlkZXZpY2VfdW5yZWdpc3RlcihkZXYp
OworCQkJcmV0dXJuIGVycjsKKwkJfQorCX0KKworCXJldHVybiAwOworfQorCitzdGF0aWMgc3Ry
dWN0IHBjcHUgKmNyZWF0ZV9hbmRfcmVnaXN0ZXJfcGNwdShzdHJ1Y3QgeGVucGZfcGNwdWluZm8g
KmluZm8pCit7CisJc3RydWN0IHBjcHUgKnBjcHU7CisJaW50IGVycjsKKworCWlmIChpbmZvLT5m
bGFncyAmIFhFTl9QQ1BVX0ZMQUdTX0lOVkFMSUQpCisJCXJldHVybiBFUlJfUFRSKC1FTk9ERVYp
OworCisJcGNwdSA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBwY3B1KSwgR0ZQX0tFUk5FTCk7CisJ
aWYgKCFwY3B1KQorCQlyZXR1cm4gRVJSX1BUUigtRU5PTUVNKTsKKworCUlOSVRfTElTVF9IRUFE
KCZwY3B1LT5saXN0KTsKKwlwY3B1LT5jcHVfaWQgPSBpbmZvLT54ZW5fY3B1aWQ7CisJcGNwdS0+
ZmxhZ3MgPSBpbmZvLT5mbGFnczsKKworCS8qIE5lZWQgaG9sZCBvbiB4ZW5fcGNwdV9sb2NrIGJl
Zm9yZSBwY3B1IGxpc3QgbWFuaXB1bGF0aW9ucyAqLworCWxpc3RfYWRkX3RhaWwoJnBjcHUtPmxp
c3QsICZ4ZW5fcGNwdXMpOworCisJZXJyID0gcmVnaXN0ZXJfcGNwdShwY3B1KTsKKwlpZiAoZXJy
KSB7CisJCXByX3dhcm5pbmcoWEVOX1BDUFUgIkZhaWxlZCB0byByZWdpc3RlciBwY3B1JXVcbiIs
CisJCQkgICBpbmZvLT54ZW5fY3B1aWQpOworCQlyZXR1cm4gRVJSX1BUUigtRU5PRU5UKTsKKwl9
CisKKwlyZXR1cm4gcGNwdTsKK30KKworLyoKKyAqIENhbGxlciBzaG91bGQgaG9sZCB0aGUgeGVu
X3BjcHVfbG9jaworICovCitzdGF0aWMgaW50IHN5bmNfcGNwdSh1aW50MzJfdCBjcHUsIHVpbnQz
Ml90ICptYXhfY3B1KQoreworCWludCByZXQ7CisJc3RydWN0IHBjcHUgKnBjcHUgPSBOVUxMOwor
CXN0cnVjdCB4ZW5wZl9wY3B1aW5mbyAqaW5mbzsKKwlzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wIG9w
ID0geworCQkuY21kICAgICAgICAgICAgICAgICAgID0gWEVOUEZfZ2V0X2NwdWluZm8sCisJCS5p
bnRlcmZhY2VfdmVyc2lvbiAgICAgPSBYRU5QRl9JTlRFUkZBQ0VfVkVSU0lPTiwKKwkJLnUucGNw
dV9pbmZvLnhlbl9jcHVpZCA9IGNwdSwKKwl9OworCisJcmV0ID0gSFlQRVJWSVNPUl9kb20wX29w
KCZvcCk7CisJaWYgKHJldCkKKwkJcmV0dXJuIHJldDsKKworCWluZm8gPSAmb3AudS5wY3B1X2lu
Zm87CisJaWYgKG1heF9jcHUpCisJCSptYXhfY3B1ID0gaW5mby0+bWF4X3ByZXNlbnQ7CisKKwlw
Y3B1ID0gZ2V0X3BjcHUoY3B1KTsKKworCS8qCisJICogT25seSB0aG9zZSBhdCBjcHUgcHJlc2Vu
dCBtYXAgaGFzIGl0cyBzeXMgaW50ZXJmYWNlLgorCSAqLworCWlmIChpbmZvLT5mbGFncyAmIFhF
Tl9QQ1BVX0ZMQUdTX0lOVkFMSUQpIHsKKwkJaWYgKHBjcHUpCisJCQl1bnJlZ2lzdGVyX2FuZF9y
ZW1vdmVfcGNwdShwY3B1KTsKKwkJcmV0dXJuIDA7CisJfQorCisJaWYgKCFwY3B1KSB7CisJCXBj
cHUgPSBjcmVhdGVfYW5kX3JlZ2lzdGVyX3BjcHUoaW5mbyk7CisJCWlmIChJU19FUlJfT1JfTlVM
TChwY3B1KSkKKwkJCXJldHVybiAtRU5PREVWOworCX0gZWxzZQorCQlwY3B1X29ubGluZV9zdGF0
dXMoaW5mbywgcGNwdSk7CisKKwlyZXR1cm4gMDsKK30KKworLyoKKyAqIFN5bmMgZG9tMCdzIHBj
cHUgaW5mb3JtYXRpb24gd2l0aCB4ZW4gaHlwZXJ2aXNvcidzCisgKi8KK3N0YXRpYyBpbnQgeGVu
X3N5bmNfcGNwdXModm9pZCkKK3sKKwkvKgorCSAqIEJvb3QgY3B1IGFsd2F5cyBoYXZlIGNwdV9p
ZCAwIGluIHhlbgorCSAqLworCXVpbnQzMl90IGNwdSA9IDAsIG1heF9jcHUgPSAwOworCWludCBl
cnIgPSAwOworCXN0cnVjdCBwY3B1ICpwY3B1LCAqdG1wOworCisJbXV0ZXhfbG9jaygmeGVuX3Bj
cHVfbG9jayk7CisKKwl3aGlsZSAoIWVyciAmJiAoY3B1IDw9IG1heF9jcHUpKSB7CisJCWVyciA9
IHN5bmNfcGNwdShjcHUsICZtYXhfY3B1KTsKKwkJY3B1Kys7CisJfQorCisJaWYgKGVycikKKwkJ
bGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKHBjcHUsIHRtcCwgJnhlbl9wY3B1cywgbGlzdCkKKwkJ
CXVucmVnaXN0ZXJfYW5kX3JlbW92ZV9wY3B1KHBjcHUpOworCisJbXV0ZXhfdW5sb2NrKCZ4ZW5f
cGNwdV9sb2NrKTsKKworCXJldHVybiBlcnI7Cit9CisKK3N0YXRpYyB2b2lkIHhlbl9wY3B1X3dv
cmtfZm4oc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQoreworCXhlbl9zeW5jX3BjcHVzKCk7Cit9
CitzdGF0aWMgREVDTEFSRV9XT1JLKHhlbl9wY3B1X3dvcmssIHhlbl9wY3B1X3dvcmtfZm4pOwor
CitzdGF0aWMgaXJxcmV0dXJuX3QgeGVuX3BjcHVfaW50ZXJydXB0KGludCBpcnEsIHZvaWQgKmRl
dl9pZCkKK3sKKwlzY2hlZHVsZV93b3JrKCZ4ZW5fcGNwdV93b3JrKTsKKwlyZXR1cm4gSVJRX0hB
TkRMRUQ7Cit9CisKK3N0YXRpYyBpbnQgX19pbml0IHhlbl9wY3B1X2luaXQodm9pZCkKK3sKKwlp
bnQgaXJxLCByZXQ7CisKKwlpZiAoIXhlbl9pbml0aWFsX2RvbWFpbigpKQorCQlyZXR1cm4gLUVO
T0RFVjsKKworCWlycSA9IGJpbmRfdmlycV90b19pcnFoYW5kbGVyKFZJUlFfUENQVV9TVEFURSwg
MCwKKwkJCQkgICAgICB4ZW5fcGNwdV9pbnRlcnJ1cHQsIDAsCisJCQkJICAgICAgInhlbi1wY3B1
IiwgTlVMTCk7CisJaWYgKGlycSA8IDApIHsKKwkJcHJfd2FybmluZyhYRU5fUENQVSAiRmFpbGVk
IHRvIGJpbmQgcGNwdSB2aXJxXG4iKTsKKwkJcmV0dXJuIGlycTsKKwl9CisKKwlyZXQgPSBzdWJz
eXNfc3lzdGVtX3JlZ2lzdGVyKCZ4ZW5fcGNwdV9zdWJzeXMsIE5VTEwpOworCWlmIChyZXQpIHsK
KwkJcHJfd2FybmluZyhYRU5fUENQVSAiRmFpbGVkIHRvIHJlZ2lzdGVyIHBjcHUgc3Vic3lzXG4i
KTsKKwkJZ290byBlcnIxOworCX0KKworCXJldCA9IHhlbl9zeW5jX3BjcHVzKCk7CisJaWYgKHJl
dCkgeworCQlwcl93YXJuaW5nKFhFTl9QQ1BVICJGYWlsZWQgdG8gc3luYyBwY3B1IGluZm9cbiIp
OworCQlnb3RvIGVycjI7CisJfQorCisJcmV0dXJuIDA7CisKK2VycjI6CisJYnVzX3VucmVnaXN0
ZXIoJnhlbl9wY3B1X3N1YnN5cyk7CitlcnIxOgorCXVuYmluZF9mcm9tX2lycWhhbmRsZXIoaXJx
LCBOVUxMKTsKKwlyZXR1cm4gcmV0OworfQorYXJjaF9pbml0Y2FsbCh4ZW5fcGNwdV9pbml0KTsK
ZGlmZiAtLWdpdCBhL2luY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oIGIvaW5jbHVkZS94
ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgKaW5kZXggNDg2NjUzZi4uNjFmYTY2MSAxMDA2NDQKLS0t
IGEvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgKKysrIGIvaW5jbHVkZS94ZW4vaW50
ZXJmYWNlL3BsYXRmb3JtLmgKQEAgLTMxNCw2ICszMTQsMTMgQEAgc3RydWN0IHhlbnBmX3BjcHVp
bmZvIHsKIH07CiBERUZJTkVfR1VFU1RfSEFORExFX1NUUlVDVCh4ZW5wZl9wY3B1aW5mbyk7CiAK
KyNkZWZpbmUgWEVOUEZfY3B1X29ubGluZQk1NgorI2RlZmluZSBYRU5QRl9jcHVfb2ZmbGluZQk1
Nworc3RydWN0IHhlbnBmX2NwdV9vbCB7CisJdWludDMyX3QgY3B1aWQ7Cit9OworREVGSU5FX0dV
RVNUX0hBTkRMRV9TVFJVQ1QoeGVucGZfY3B1X29sKTsKKwogc3RydWN0IHhlbl9wbGF0Zm9ybV9v
cCB7CiAJdWludDMyX3QgY21kOwogCXVpbnQzMl90IGludGVyZmFjZV92ZXJzaW9uOyAvKiBYRU5Q
Rl9JTlRFUkZBQ0VfVkVSU0lPTiAqLwpAQCAtMzMwLDYgKzMzNyw3IEBAIHN0cnVjdCB4ZW5fcGxh
dGZvcm1fb3AgewogCQlzdHJ1Y3QgeGVucGZfZ2V0aWRsZXRpbWUgICAgICAgZ2V0aWRsZXRpbWU7
CiAJCXN0cnVjdCB4ZW5wZl9zZXRfcHJvY2Vzc29yX3BtaW5mbyBzZXRfcG1pbmZvOwogCQlzdHJ1
Y3QgeGVucGZfcGNwdWluZm8gICAgICAgICAgcGNwdV9pbmZvOworCQlzdHJ1Y3QgeGVucGZfY3B1
X29sICAgICAgICAgICAgY3B1X29sOwogCQl1aW50OF90ICAgICAgICAgICAgICAgICAgICAgICAg
cGFkWzEyOF07CiAJfSB1OwogfTsKZGlmZiAtLWdpdCBhL2luY2x1ZGUveGVuL2ludGVyZmFjZS94
ZW4uaCBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS94ZW4uaAppbmRleCBhODkwODA0Li4wODAxNDY4
IDEwMDY0NAotLS0gYS9pbmNsdWRlL3hlbi9pbnRlcmZhY2UveGVuLmgKKysrIGIvaW5jbHVkZS94
ZW4vaW50ZXJmYWNlL3hlbi5oCkBAIC04MCw2ICs4MCw3IEBACiAjZGVmaW5lIFZJUlFfQ09OU09M
RSAgICAyICAvKiAoRE9NMCkgQnl0ZXMgcmVjZWl2ZWQgb24gZW1lcmdlbmN5IGNvbnNvbGUuICov
CiAjZGVmaW5lIFZJUlFfRE9NX0VYQyAgICAzICAvKiAoRE9NMCkgRXhjZXB0aW9uYWwgZXZlbnQg
Zm9yIHNvbWUgZG9tYWluLiAgICovCiAjZGVmaW5lIFZJUlFfREVCVUdHRVIgICA2ICAvKiAoRE9N
MCkgQSBkb21haW4gaGFzIHBhdXNlZCBmb3IgZGVidWdnaW5nLiAgICovCisjZGVmaW5lIFZJUlFf
UENQVV9TVEFURSA5ICAvKiAoRE9NMCkgUENQVSBzdGF0ZSBjaGFuZ2VkICAgICAgICAgICAgICAg
ICAgICovCiAKIC8qIEFyY2hpdGVjdHVyZS1zcGVjaWZpYyBWSVJRIGRlZmluaXRpb25zLiAqLwog
I2RlZmluZSBWSVJRX0FSQ0hfMCAgICAxNgotLSAKMS43LjEKCg==

--_002_DE8DF0795D48FD4CA783C40EC82923352259E4SHSMSX101ccrcorpi_--
