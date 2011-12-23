Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab1LWKZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:25:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:54874 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab1LWKZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:25:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="99638305"
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
Subject: [PATCH 03/10] Xen: Export host physical CPU information to dom0
Thread-Topic: [PATCH 03/10] Xen: Export host physical CPU information to dom0
Thread-Index: AczBXS3xndCwjv8tTQC62IA/xc76Ag==
Date: Fri, 23 Dec 2011 10:25:23 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233596CC@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC829233596CCSHSMSX101ccrcorpint_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC829233596CCSHSMSX101ccrcorpint_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 04151aa18b48a452cc9d0696f36aa96c690ca011 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Thu, 8 Dec 2011 22:28:07 +0800
Subject: [PATCH 03/10] Xen: Export host physical CPU information to dom0

This patch rebased from Jeremy's pvops commit
3b34cd19627c6e191b15fd6cb59f997b8db21e19 and
68320323a51c2378aca433c76157d9e66104ff1e

This patch expose host's physical CPU information to dom0 in sysfs, so
that dom0's management tools can control the physical CPU if needed.

It also provides interface in sysfs to logical online/offline a physical CP=
U.

Notice: The information in dom0 is synced with xen hypervisor asynchronousl=
y.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/Makefile             |    2 +-
 drivers/xen/pcpu.c               |  452 ++++++++++++++++++++++++++++++++++=
++++
 include/xen/interface/platform.h |   28 +++
 include/xen/interface/xen.h      |    1 +
 include/xen/pcpu.h               |   32 +++
 5 files changed, 514 insertions(+), 1 deletions(-)
 create mode 100644 drivers/xen/pcpu.c
 create mode 100644 include/xen/pcpu.h

diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 405cce9..aedaf48 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,4 +1,4 @@
-obj-y	+=3D grant-table.o features.o events.o manage.o balloon.o
+obj-y	+=3D grant-table.o features.o events.o manage.o balloon.o pcpu.o
 obj-y	+=3D xenbus/
=20
 nostackp :=3D $(call cc-option, -fno-stack-protector)
diff --git a/drivers/xen/pcpu.c b/drivers/xen/pcpu.c
new file mode 100644
index 0000000..6d1a770
--- /dev/null
+++ b/drivers/xen/pcpu.c
@@ -0,0 +1,452 @@
+/*
+ * pcpu.c - management physical cpu in dom0 environment
+ */
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <asm/xen/hypervisor.h>
+#include <asm/xen/hypercall.h>
+#include <linux/cpu.h>
+#include <xen/xenbus.h>
+#include <xen/pcpu.h>
+#include <xen/events.h>
+#include <xen/acpi.h>
+
+static struct sysdev_class xen_pcpu_sysdev_class =3D {
+	.name =3D "xen_pcpu",
+};
+
+static DEFINE_MUTEX(xen_pcpu_lock);
+static RAW_NOTIFIER_HEAD(xen_pcpu_chain);
+
+/* No need for irq disable since hotplug notify is in workqueue context */
+#define get_pcpu_lock() mutex_lock(&xen_pcpu_lock);
+#define put_pcpu_lock() mutex_unlock(&xen_pcpu_lock);
+
+struct xen_pcpus {
+	struct list_head list;
+	int present;
+};
+static struct xen_pcpus xen_pcpus;
+
+int register_xen_pcpu_notifier(struct notifier_block *nb)
+{
+	int ret;
+
+	/* All refer to the chain notifier is protected by the pcpu_lock */
+	get_pcpu_lock();
+	ret =3D raw_notifier_chain_register(&xen_pcpu_chain, nb);
+	put_pcpu_lock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_xen_pcpu_notifier);
+
+void unregister_xen_pcpu_notifier(struct notifier_block *nb)
+{
+	get_pcpu_lock();
+	raw_notifier_chain_unregister(&xen_pcpu_chain, nb);
+	put_pcpu_lock();
+}
+EXPORT_SYMBOL_GPL(unregister_xen_pcpu_notifier);
+
+static int xen_pcpu_down(uint32_t xen_id)
+{
+	int ret;
+	xen_platform_op_t op =3D {
+		.cmd			=3D XENPF_cpu_offline,
+		.interface_version	=3D XENPF_INTERFACE_VERSION,
+		.u.cpu_ol.cpuid	=3D xen_id,
+	};
+
+	ret =3D HYPERVISOR_dom0_op(&op);
+	return ret;
+}
+
+static int xen_pcpu_up(uint32_t xen_id)
+{
+	int ret;
+	xen_platform_op_t op =3D {
+		.cmd			=3D XENPF_cpu_online,
+		.interface_version	=3D XENPF_INTERFACE_VERSION,
+		.u.cpu_ol.cpuid	=3D xen_id,
+	};
+
+	ret =3D HYPERVISOR_dom0_op(&op);
+	return ret;
+}
+
+static ssize_t show_online(struct sys_device *dev,
+			struct sysdev_attribute *attr,
+			char *buf)
+{
+	struct pcpu *cpu =3D container_of(dev, struct pcpu, sysdev);
+
+	return sprintf(buf, "%u\n", !!(cpu->flags & XEN_PCPU_FLAGS_ONLINE));
+}
+
+static ssize_t __ref store_online(struct sys_device *dev,
+				  struct sysdev_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct pcpu *cpu =3D container_of(dev, struct pcpu, sysdev);
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
+
+static SYSDEV_ATTR(online, 0644, show_online, store_online);
+
+static ssize_t show_apicid(struct sys_device *dev,
+			struct sysdev_attribute *attr,
+			char *buf)
+{
+	struct pcpu *cpu =3D container_of(dev, struct pcpu, sysdev);
+
+	return sprintf(buf, "%u\n", cpu->apic_id);
+}
+
+static ssize_t show_acpiid(struct sys_device *dev,
+			struct sysdev_attribute *attr,
+			char *buf)
+{
+	struct pcpu *cpu =3D container_of(dev, struct pcpu, sysdev);
+
+	return sprintf(buf, "%u\n", cpu->acpi_id);
+}
+static SYSDEV_ATTR(apic_id, 0444, show_apicid, NULL);
+static SYSDEV_ATTR(acpi_id, 0444, show_acpiid, NULL);
+
+static int xen_pcpu_free(struct pcpu *pcpu)
+{
+	if (!pcpu)
+		return 0;
+
+	sysdev_remove_file(&pcpu->sysdev, &attr_online);
+	sysdev_unregister(&pcpu->sysdev);
+	list_del(&pcpu->pcpu_list);
+	kfree(pcpu);
+
+	return 0;
+}
+
+static inline int same_pcpu(struct xenpf_pcpuinfo *info,
+			    struct pcpu *pcpu)
+{
+	return (pcpu->apic_id =3D=3D info->apic_id) &&
+		(pcpu->xen_id =3D=3D info->xen_cpuid);
+}
+
+/*
+ * Return 1 if online status changed
+ */
+static int xen_pcpu_online_check(struct xenpf_pcpuinfo *info,
+				 struct pcpu *pcpu)
+{
+	int result =3D 0;
+
+	if (info->xen_cpuid !=3D pcpu->xen_id)
+		return 0;
+
+	if (xen_pcpu_online(info->flags) && !xen_pcpu_online(pcpu->flags)) {
+		/* the pcpu is onlined */
+		pcpu->flags |=3D XEN_PCPU_FLAGS_ONLINE;
+		kobject_uevent(&pcpu->sysdev.kobj, KOBJ_ONLINE);
+		raw_notifier_call_chain(&xen_pcpu_chain,
+			XEN_PCPU_ONLINE, (void *)(long)pcpu->xen_id);
+		result =3D 1;
+	} else if (!xen_pcpu_online(info->flags) &&
+		 xen_pcpu_online(pcpu->flags))  {
+		/* The pcpu is offlined now */
+		pcpu->flags &=3D ~XEN_PCPU_FLAGS_ONLINE;
+		kobject_uevent(&pcpu->sysdev.kobj, KOBJ_OFFLINE);
+		raw_notifier_call_chain(&xen_pcpu_chain,
+			XEN_PCPU_OFFLINE, (void *)(long)pcpu->xen_id);
+		result =3D 1;
+	}
+
+	return result;
+}
+
+static int pcpu_sysdev_init(struct pcpu *cpu)
+{
+	int error;
+
+	error =3D sysdev_register(&cpu->sysdev);
+	if (error) {
+		printk(KERN_WARNING "xen_pcpu_add: Failed to register pcpu\n");
+		kfree(cpu);
+		return -1;
+	}
+	sysdev_create_file(&cpu->sysdev, &attr_online);
+	sysdev_create_file(&cpu->sysdev, &attr_apic_id);
+	sysdev_create_file(&cpu->sysdev, &attr_acpi_id);
+	return 0;
+}
+
+static struct pcpu *get_pcpu(int xen_id)
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
+static struct pcpu *init_pcpu(struct xenpf_pcpuinfo *info)
+{
+	struct pcpu *pcpu;
+
+	if (info->flags & XEN_PCPU_FLAGS_INVALID)
+		return NULL;
+
+	/* The PCPU is just added */
+	pcpu =3D kzalloc(sizeof(struct pcpu), GFP_KERNEL);
+	if (!pcpu)
+		return NULL;
+
+	INIT_LIST_HEAD(&pcpu->pcpu_list);
+	pcpu->xen_id =3D info->xen_cpuid;
+	pcpu->apic_id =3D info->apic_id;
+	pcpu->acpi_id =3D info->acpi_id;
+	pcpu->flags =3D info->flags;
+
+	pcpu->sysdev.cls =3D &xen_pcpu_sysdev_class;
+	pcpu->sysdev.id =3D info->xen_cpuid;
+
+	if (pcpu_sysdev_init(pcpu)) {
+		kfree(pcpu);
+		return NULL;
+	}
+
+	list_add_tail(&pcpu->pcpu_list, &xen_pcpus.list);
+	raw_notifier_call_chain(&xen_pcpu_chain,
+				XEN_PCPU_ADD,
+				(void *)(long)pcpu->xen_id);
+	return pcpu;
+}
+
+#define PCPU_NO_CHANGE			0
+#define PCPU_ADDED			1
+#define PCPU_ONLINE_OFFLINE		2
+#define PCPU_REMOVED			3
+/*
+ * Caller should hold the pcpu lock
+ * < 0: Something wrong
+ * 0: No changes
+ * > 0: State changed
+ */
+static struct pcpu *_sync_pcpu(int cpu_num, int *max_id, int *result)
+{
+	struct pcpu *pcpu =3D NULL;
+	struct xenpf_pcpuinfo *info;
+	xen_platform_op_t op =3D {
+		.cmd            =3D XENPF_get_cpuinfo,
+		.interface_version  =3D XENPF_INTERFACE_VERSION,
+	};
+	int ret;
+
+	*result =3D -1;
+
+	info =3D &op.u.pcpu_info;
+	info->xen_cpuid =3D cpu_num;
+
+	ret =3D HYPERVISOR_dom0_op(&op);
+	if (ret)
+		return NULL;
+
+	if (max_id)
+		*max_id =3D op.u.pcpu_info.max_present;
+
+	pcpu =3D get_pcpu(cpu_num);
+
+	if (info->flags & XEN_PCPU_FLAGS_INVALID) {
+		/* The pcpu has been removed */
+		*result =3D PCPU_NO_CHANGE;
+		if (pcpu) {
+			raw_notifier_call_chain(&xen_pcpu_chain,
+			  XEN_PCPU_REMOVE,
+			  (void *)(long)pcpu->xen_id);
+			xen_pcpu_free(pcpu);
+			*result =3D PCPU_REMOVED;
+		}
+		return NULL;
+	}
+
+
+	if (!pcpu) {
+		*result =3D PCPU_ADDED;
+		pcpu =3D init_pcpu(info);
+		if (pcpu =3D=3D NULL) {
+			printk(KERN_WARNING "Failed to init pcpu %x\n",
+			  info->xen_cpuid);
+			  *result =3D -1;
+		}
+	} else {
+		*result =3D PCPU_NO_CHANGE;
+		/*
+		 * Old PCPU is replaced with a new pcpu, this means
+		 * several virq is missed, will it happen?
+		 */
+		if (!same_pcpu(info, pcpu)) {
+			printk(KERN_WARNING "Pcpu %x changed!\n",
+			  pcpu->xen_id);
+			pcpu->apic_id =3D info->apic_id;
+			pcpu->acpi_id =3D info->acpi_id;
+		}
+		if (xen_pcpu_online_check(info, pcpu))
+			*result =3D PCPU_ONLINE_OFFLINE;
+	}
+	return pcpu;
+}
+
+int xen_pcpu_index(uint32_t id, int is_acpiid)
+{
+	int cpu_num =3D 0, max_id =3D 0, ret;
+	xen_platform_op_t op =3D {
+		.cmd            =3D XENPF_get_cpuinfo,
+		.interface_version  =3D XENPF_INTERFACE_VERSION,
+	};
+	struct xenpf_pcpuinfo *info =3D &op.u.pcpu_info;
+
+	info->xen_cpuid =3D 0;
+	ret =3D HYPERVISOR_dom0_op(&op);
+	if (ret)
+		return -1;
+	max_id =3D op.u.pcpu_info.max_present;
+
+	while ((cpu_num <=3D max_id)) {
+		info->xen_cpuid =3D cpu_num;
+		ret =3D HYPERVISOR_dom0_op(&op);
+		if (ret)
+			continue;
+
+		if (op.u.pcpu_info.max_present > max_id)
+			max_id =3D op.u.pcpu_info.max_present;
+		if (id =3D=3D (is_acpiid ? info->acpi_id : info->apic_id))
+			return cpu_num;
+		cpu_num++;
+	}
+
+    return -1;
+}
+EXPORT_SYMBOL(xen_pcpu_index);
+
+/*
+ * Sync dom0's pcpu information with xen hypervisor's
+ */
+static int xen_sync_pcpus(void)
+{
+	/*
+	 * Boot cpu always have cpu_id 0 in xen
+	 */
+	int cpu_num =3D 0, max_id =3D 0, result =3D 0, present =3D 0;
+	struct list_head *elem, *tmp;
+	struct pcpu *pcpu;
+
+	get_pcpu_lock();
+
+	while ((result >=3D 0) && (cpu_num <=3D max_id)) {
+		pcpu =3D _sync_pcpu(cpu_num, &max_id, &result);
+
+		printk(KERN_DEBUG "sync cpu %x get result %x max_id %x\n",
+			cpu_num, result, max_id);
+
+		switch (result)	{
+		case PCPU_NO_CHANGE:
+			if (pcpu)
+				present++;
+			break;
+		case PCPU_ADDED:
+		case PCPU_ONLINE_OFFLINE:
+			present++;
+		case PCPU_REMOVED:
+			break;
+		default:
+			printk(KERN_WARNING "Failed to sync pcpu %x\n",
+			  cpu_num);
+			break;
+
+		}
+		cpu_num++;
+	}
+
+	if (result < 0) {
+		list_for_each_safe(elem, tmp, &xen_pcpus.list) {
+			pcpu =3D list_entry(elem, struct pcpu, pcpu_list);
+			xen_pcpu_free(pcpu);
+		}
+		present =3D 0;
+	}
+
+	xen_pcpus.present =3D present;
+
+	put_pcpu_lock();
+
+	return 0;
+}
+
+static void xen_pcpu_dpc(struct work_struct *work)
+{
+	if (xen_sync_pcpus() < 0)
+		printk(KERN_WARNING
+			"xen_pcpu_dpc: Failed to sync pcpu information\n");
+}
+static DECLARE_WORK(xen_pcpu_work, xen_pcpu_dpc);
+
+int xen_pcpu_hotplug(int type, uint32_t apic_id)
+{
+	schedule_work(&xen_pcpu_work);
+
+	return 0;
+}
+EXPORT_SYMBOL(xen_pcpu_hotplug);
+
+static irqreturn_t xen_pcpu_interrupt(int irq, void *dev_id)
+{
+	schedule_work(&xen_pcpu_work);
+	return IRQ_HANDLED;
+}
+
+static int __init xen_pcpu_init(void)
+{
+	int err;
+
+	if (!xen_initial_domain())
+		return 0;
+
+	err =3D sysdev_class_register(&xen_pcpu_sysdev_class);
+	if (err) {
+		printk(KERN_WARNING
+			"xen_pcpu_init: register xen_pcpu sysdev Failed!\n");
+		return err;
+	}
+
+	INIT_LIST_HEAD(&xen_pcpus.list);
+	xen_pcpus.present =3D 0;
+
+	xen_sync_pcpus();
+	if (xen_pcpus.present > 0)
+		err =3D bind_virq_to_irqhandler(VIRQ_PCPU_STATE,
+			0, xen_pcpu_interrupt, 0, "pcpu", NULL);
+	if (err < 0)
+		printk(KERN_WARNING "xen_pcpu_init: "
+			"Failed to bind pcpu_state virq\n"
+			"You will lost latest information! \n");
+	return err;
+}
+
+arch_initcall(xen_pcpu_init);
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platf=
orm.h
index c168468..47ffe16 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -297,6 +297,31 @@ struct xenpf_set_processor_pminfo {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_set_processor_pminfo);
=20
+#define XENPF_get_cpuinfo 55
+struct xenpf_pcpuinfo {
+	/* IN */
+	uint32_t xen_cpuid;
+	/* OUT */
+	/* The maxium cpu_id that is present */
+	uint32_t max_present;
+#define XEN_PCPU_FLAGS_ONLINE   1
+	/* Correponding xen_cpuid is not present*/
+#define XEN_PCPU_FLAGS_INVALID  2
+	uint32_t flags;
+	uint32_t apic_id;
+	uint32_t acpi_id;
+};
+typedef struct xenpf_pcpuinfo xenpf_pcpuinfo_t;
+DEFINE_GUEST_HANDLE_STRUCT(xenpf_pcpuinfo_t);
+
+#define XENPF_cpu_online    56
+#define XENPF_cpu_offline   57
+struct xenpf_cpu_ol {
+    uint32_t cpuid;
+};
+typedef struct xenpf_cpu_ol xenpf_cpu_ol_t;
+DEFINE_GUEST_HANDLE_STRUCT(xenpf_cpu_ol_t);
+
 struct xen_platform_op {
 	uint32_t cmd;
 	uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
@@ -312,9 +337,12 @@ struct xen_platform_op {
 		struct xenpf_change_freq       change_freq;
 		struct xenpf_getidletime       getidletime;
 		struct xenpf_set_processor_pminfo set_pminfo;
+		struct xenpf_pcpuinfo          pcpu_info;
+		struct xenpf_cpu_ol            cpu_ol;
 		uint8_t                        pad[128];
 	} u;
 };
+typedef struct xen_platform_op xen_platform_op_t;
 DEFINE_GUEST_HANDLE_STRUCT(xen_platform_op_t);
=20
 #endif /* __XEN_PUBLIC_PLATFORM_H__ */
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index 6a6e914..5a91c66 100644
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
diff --git a/include/xen/pcpu.h b/include/xen/pcpu.h
new file mode 100644
index 0000000..7e8f9d1
--- /dev/null
+++ b/include/xen/pcpu.h
@@ -0,0 +1,32 @@
+#ifndef _XEN_PCPU_H
+#define _XEN_PCPU_H
+
+#include <xen/interface/platform.h>
+#include <linux/sysdev.h>
+
+extern int xen_pcpu_hotplug(int type, uint32_t apic_id);
+#define XEN_PCPU_ONLINE     0x01
+#define XEN_PCPU_OFFLINE    0x02
+#define XEN_PCPU_ADD        0x04
+#define XEN_PCPU_REMOVE     0x08
+
+struct pcpu {
+	struct list_head pcpu_list;
+	struct sys_device sysdev;
+	uint32_t xen_id;
+	uint32_t apic_id;
+	uint32_t acpi_id;
+	uint32_t flags;
+};
+
+static inline int xen_pcpu_online(uint32_t flags)
+{
+	return !!(flags & XEN_PCPU_FLAGS_ONLINE);
+}
+
+extern int register_xen_pcpu_notifier(struct notifier_block *nb);
+
+extern void unregister_xen_pcpu_notifier(struct notifier_block *nb);
+
+extern int xen_pcpu_index(uint32_t acpi_id, int is_acpiid);
+#endif
--=20
1.6.5.6

--_002_DE8DF0795D48FD4CA783C40EC829233596CCSHSMSX101ccrcorpint_
Content-Type: application/octet-stream;
	name="0003-Xen-Export-host-physical-CPU-information-to-dom0.patch"
Content-Description: 0003-Xen-Export-host-physical-CPU-information-to-dom0.patch
Content-Disposition: attachment;
	filename="0003-Xen-Export-host-physical-CPU-information-to-dom0.patch";
	size=15036; creation-date="Wed, 14 Dec 2011 15:20:15 GMT";
	modification-date="Wed, 14 Dec 2011 15:03:34 GMT"
Content-Transfer-Encoding: base64

RnJvbSAwNDE1MWFhMThiNDhhNDUyY2M5ZDA2OTZmMzZhYTk2YzY5MGNhMDExIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBUaHUsIDggRGVjIDIwMTEgMjI6Mjg6MDcgKzA4MDAKU3ViamVjdDogW1BBVENIIDAzLzEw
XSBYZW46IEV4cG9ydCBob3N0IHBoeXNpY2FsIENQVSBpbmZvcm1hdGlvbiB0byBkb20wCgpUaGlz
IHBhdGNoIHJlYmFzZWQgZnJvbSBKZXJlbXkncyBwdm9wcyBjb21taXQKM2IzNGNkMTk2MjdjNmUx
OTFiMTVmZDZjYjU5Zjk5N2I4ZGIyMWUxOSBhbmQKNjgzMjAzMjNhNTFjMjM3OGFjYTQzM2M3NjE1
N2Q5ZTY2MTA0ZmYxZQoKVGhpcyBwYXRjaCBleHBvc2UgaG9zdCdzIHBoeXNpY2FsIENQVSBpbmZv
cm1hdGlvbiB0byBkb20wIGluIHN5c2ZzLCBzbwp0aGF0IGRvbTAncyBtYW5hZ2VtZW50IHRvb2xz
IGNhbiBjb250cm9sIHRoZSBwaHlzaWNhbCBDUFUgaWYgbmVlZGVkLgoKSXQgYWxzbyBwcm92aWRl
cyBpbnRlcmZhY2UgaW4gc3lzZnMgdG8gbG9naWNhbCBvbmxpbmUvb2ZmbGluZSBhIHBoeXNpY2Fs
IENQVS4KCk5vdGljZTogVGhlIGluZm9ybWF0aW9uIGluIGRvbTAgaXMgc3luY2VkIHdpdGggeGVu
IGh5cGVydmlzb3IgYXN5bmNocm9ub3VzbHkuCgpTaWduZWQtb2ZmLWJ5OiBMaXUsIEppbnNvbmcg
PGppbnNvbmcubGl1QGludGVsLmNvbT4KU2lnbmVkLW9mZi1ieTogSmlhbmcsIFl1bmhvbmcgPHl1
bmhvbmcuamlhbmdAaW50ZWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBKZXJlbXkgRml0emhhcmRpbmdl
IDxqZXJlbXkuZml0emhhcmRpbmdlQGNpdHJpeC5jb20+Ci0tLQogZHJpdmVycy94ZW4vTWFrZWZp
bGUgICAgICAgICAgICAgfCAgICAyICstCiBkcml2ZXJzL3hlbi9wY3B1LmMgICAgICAgICAgICAg
ICB8ICA0NTIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGluY2x1ZGUv
eGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oIHwgICAyOCArKysKIGluY2x1ZGUveGVuL2ludGVyZmFj
ZS94ZW4uaCAgICAgIHwgICAgMSArCiBpbmNsdWRlL3hlbi9wY3B1LmggICAgICAgICAgICAgICB8
ICAgMzIgKysrCiA1IGZpbGVzIGNoYW5nZWQsIDUxNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9u
cygtKQogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMveGVuL3BjcHUuYwogY3JlYXRlIG1vZGUg
MTAwNjQ0IGluY2x1ZGUveGVuL3BjcHUuaAoKZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVuL01ha2Vm
aWxlIGIvZHJpdmVycy94ZW4vTWFrZWZpbGUKaW5kZXggNDA1Y2NlOS4uYWVkYWY0OCAxMDA2NDQK
LS0tIGEvZHJpdmVycy94ZW4vTWFrZWZpbGUKKysrIGIvZHJpdmVycy94ZW4vTWFrZWZpbGUKQEAg
LTEsNCArMSw0IEBACi1vYmoteQkrPSBncmFudC10YWJsZS5vIGZlYXR1cmVzLm8gZXZlbnRzLm8g
bWFuYWdlLm8gYmFsbG9vbi5vCitvYmoteQkrPSBncmFudC10YWJsZS5vIGZlYXR1cmVzLm8gZXZl
bnRzLm8gbWFuYWdlLm8gYmFsbG9vbi5vIHBjcHUubwogb2JqLXkJKz0geGVuYnVzLwogCiBub3N0
YWNrcCA6PSAkKGNhbGwgY2Mtb3B0aW9uLCAtZm5vLXN0YWNrLXByb3RlY3RvcikKZGlmZiAtLWdp
dCBhL2RyaXZlcnMveGVuL3BjcHUuYyBiL2RyaXZlcnMveGVuL3BjcHUuYwpuZXcgZmlsZSBtb2Rl
IDEwMDY0NAppbmRleCAwMDAwMDAwLi42ZDFhNzcwCi0tLSAvZGV2L251bGwKKysrIGIvZHJpdmVy
cy94ZW4vcGNwdS5jCkBAIC0wLDAgKzEsNDUyIEBACisvKgorICogcGNwdS5jIC0gbWFuYWdlbWVu
dCBwaHlzaWNhbCBjcHUgaW4gZG9tMCBlbnZpcm9ubWVudAorICovCisjaW5jbHVkZSA8bGludXgv
aW50ZXJydXB0Lmg+CisjaW5jbHVkZSA8bGludXgvc3BpbmxvY2suaD4KKyNpbmNsdWRlIDxhc20v
eGVuL2h5cGVydmlzb3IuaD4KKyNpbmNsdWRlIDxhc20veGVuL2h5cGVyY2FsbC5oPgorI2luY2x1
ZGUgPGxpbnV4L2NwdS5oPgorI2luY2x1ZGUgPHhlbi94ZW5idXMuaD4KKyNpbmNsdWRlIDx4ZW4v
cGNwdS5oPgorI2luY2x1ZGUgPHhlbi9ldmVudHMuaD4KKyNpbmNsdWRlIDx4ZW4vYWNwaS5oPgor
CitzdGF0aWMgc3RydWN0IHN5c2Rldl9jbGFzcyB4ZW5fcGNwdV9zeXNkZXZfY2xhc3MgPSB7CisJ
Lm5hbWUgPSAieGVuX3BjcHUiLAorfTsKKworc3RhdGljIERFRklORV9NVVRFWCh4ZW5fcGNwdV9s
b2NrKTsKK3N0YXRpYyBSQVdfTk9USUZJRVJfSEVBRCh4ZW5fcGNwdV9jaGFpbik7CisKKy8qIE5v
IG5lZWQgZm9yIGlycSBkaXNhYmxlIHNpbmNlIGhvdHBsdWcgbm90aWZ5IGlzIGluIHdvcmtxdWV1
ZSBjb250ZXh0ICovCisjZGVmaW5lIGdldF9wY3B1X2xvY2soKSBtdXRleF9sb2NrKCZ4ZW5fcGNw
dV9sb2NrKTsKKyNkZWZpbmUgcHV0X3BjcHVfbG9jaygpIG11dGV4X3VubG9jaygmeGVuX3BjcHVf
bG9jayk7CisKK3N0cnVjdCB4ZW5fcGNwdXMgeworCXN0cnVjdCBsaXN0X2hlYWQgbGlzdDsKKwlp
bnQgcHJlc2VudDsKK307CitzdGF0aWMgc3RydWN0IHhlbl9wY3B1cyB4ZW5fcGNwdXM7CisKK2lu
dCByZWdpc3Rlcl94ZW5fcGNwdV9ub3RpZmllcihzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5iKQor
eworCWludCByZXQ7CisKKwkvKiBBbGwgcmVmZXIgdG8gdGhlIGNoYWluIG5vdGlmaWVyIGlzIHBy
b3RlY3RlZCBieSB0aGUgcGNwdV9sb2NrICovCisJZ2V0X3BjcHVfbG9jaygpOworCXJldCA9IHJh
d19ub3RpZmllcl9jaGFpbl9yZWdpc3RlcigmeGVuX3BjcHVfY2hhaW4sIG5iKTsKKwlwdXRfcGNw
dV9sb2NrKCk7CisJcmV0dXJuIHJldDsKK30KK0VYUE9SVF9TWU1CT0xfR1BMKHJlZ2lzdGVyX3hl
bl9wY3B1X25vdGlmaWVyKTsKKwordm9pZCB1bnJlZ2lzdGVyX3hlbl9wY3B1X25vdGlmaWVyKHN0
cnVjdCBub3RpZmllcl9ibG9jayAqbmIpCit7CisJZ2V0X3BjcHVfbG9jaygpOworCXJhd19ub3Rp
Zmllcl9jaGFpbl91bnJlZ2lzdGVyKCZ4ZW5fcGNwdV9jaGFpbiwgbmIpOworCXB1dF9wY3B1X2xv
Y2soKTsKK30KK0VYUE9SVF9TWU1CT0xfR1BMKHVucmVnaXN0ZXJfeGVuX3BjcHVfbm90aWZpZXIp
OworCitzdGF0aWMgaW50IHhlbl9wY3B1X2Rvd24odWludDMyX3QgeGVuX2lkKQoreworCWludCBy
ZXQ7CisJeGVuX3BsYXRmb3JtX29wX3Qgb3AgPSB7CisJCS5jbWQJCQk9IFhFTlBGX2NwdV9vZmZs
aW5lLAorCQkuaW50ZXJmYWNlX3ZlcnNpb24JPSBYRU5QRl9JTlRFUkZBQ0VfVkVSU0lPTiwKKwkJ
LnUuY3B1X29sLmNwdWlkCT0geGVuX2lkLAorCX07CisKKwlyZXQgPSBIWVBFUlZJU09SX2RvbTBf
b3AoJm9wKTsKKwlyZXR1cm4gcmV0OworfQorCitzdGF0aWMgaW50IHhlbl9wY3B1X3VwKHVpbnQz
Ml90IHhlbl9pZCkKK3sKKwlpbnQgcmV0OworCXhlbl9wbGF0Zm9ybV9vcF90IG9wID0geworCQku
Y21kCQkJPSBYRU5QRl9jcHVfb25saW5lLAorCQkuaW50ZXJmYWNlX3ZlcnNpb24JPSBYRU5QRl9J
TlRFUkZBQ0VfVkVSU0lPTiwKKwkJLnUuY3B1X29sLmNwdWlkCT0geGVuX2lkLAorCX07CisKKwly
ZXQgPSBIWVBFUlZJU09SX2RvbTBfb3AoJm9wKTsKKwlyZXR1cm4gcmV0OworfQorCitzdGF0aWMg
c3NpemVfdCBzaG93X29ubGluZShzdHJ1Y3Qgc3lzX2RldmljZSAqZGV2LAorCQkJc3RydWN0IHN5
c2Rldl9hdHRyaWJ1dGUgKmF0dHIsCisJCQljaGFyICpidWYpCit7CisJc3RydWN0IHBjcHUgKmNw
dSA9IGNvbnRhaW5lcl9vZihkZXYsIHN0cnVjdCBwY3B1LCBzeXNkZXYpOworCisJcmV0dXJuIHNw
cmludGYoYnVmLCAiJXVcbiIsICEhKGNwdS0+ZmxhZ3MgJiBYRU5fUENQVV9GTEFHU19PTkxJTkUp
KTsKK30KKworc3RhdGljIHNzaXplX3QgX19yZWYgc3RvcmVfb25saW5lKHN0cnVjdCBzeXNfZGV2
aWNlICpkZXYsCisJCQkJICBzdHJ1Y3Qgc3lzZGV2X2F0dHJpYnV0ZSAqYXR0ciwKKwkJCQkgIGNv
bnN0IGNoYXIgKmJ1Ziwgc2l6ZV90IGNvdW50KQoreworCXN0cnVjdCBwY3B1ICpjcHUgPSBjb250
YWluZXJfb2YoZGV2LCBzdHJ1Y3QgcGNwdSwgc3lzZGV2KTsKKwlzc2l6ZV90IHJldDsKKworCXN3
aXRjaCAoYnVmWzBdKSB7CisJY2FzZSAnMCc6CisJCXJldCA9IHhlbl9wY3B1X2Rvd24oY3B1LT54
ZW5faWQpOworCQlicmVhazsKKwljYXNlICcxJzoKKwkJcmV0ID0geGVuX3BjcHVfdXAoY3B1LT54
ZW5faWQpOworCQlicmVhazsKKwlkZWZhdWx0OgorCQlyZXQgPSAtRUlOVkFMOworCX0KKworCWlm
IChyZXQgPj0gMCkKKwkJcmV0ID0gY291bnQ7CisJcmV0dXJuIHJldDsKK30KKworc3RhdGljIFNZ
U0RFVl9BVFRSKG9ubGluZSwgMDY0NCwgc2hvd19vbmxpbmUsIHN0b3JlX29ubGluZSk7CisKK3N0
YXRpYyBzc2l6ZV90IHNob3dfYXBpY2lkKHN0cnVjdCBzeXNfZGV2aWNlICpkZXYsCisJCQlzdHJ1
Y3Qgc3lzZGV2X2F0dHJpYnV0ZSAqYXR0ciwKKwkJCWNoYXIgKmJ1ZikKK3sKKwlzdHJ1Y3QgcGNw
dSAqY3B1ID0gY29udGFpbmVyX29mKGRldiwgc3RydWN0IHBjcHUsIHN5c2Rldik7CisKKwlyZXR1
cm4gc3ByaW50ZihidWYsICIldVxuIiwgY3B1LT5hcGljX2lkKTsKK30KKworc3RhdGljIHNzaXpl
X3Qgc2hvd19hY3BpaWQoc3RydWN0IHN5c19kZXZpY2UgKmRldiwKKwkJCXN0cnVjdCBzeXNkZXZf
YXR0cmlidXRlICphdHRyLAorCQkJY2hhciAqYnVmKQoreworCXN0cnVjdCBwY3B1ICpjcHUgPSBj
b250YWluZXJfb2YoZGV2LCBzdHJ1Y3QgcGNwdSwgc3lzZGV2KTsKKworCXJldHVybiBzcHJpbnRm
KGJ1ZiwgIiV1XG4iLCBjcHUtPmFjcGlfaWQpOworfQorc3RhdGljIFNZU0RFVl9BVFRSKGFwaWNf
aWQsIDA0NDQsIHNob3dfYXBpY2lkLCBOVUxMKTsKK3N0YXRpYyBTWVNERVZfQVRUUihhY3BpX2lk
LCAwNDQ0LCBzaG93X2FjcGlpZCwgTlVMTCk7CisKK3N0YXRpYyBpbnQgeGVuX3BjcHVfZnJlZShz
dHJ1Y3QgcGNwdSAqcGNwdSkKK3sKKwlpZiAoIXBjcHUpCisJCXJldHVybiAwOworCisJc3lzZGV2
X3JlbW92ZV9maWxlKCZwY3B1LT5zeXNkZXYsICZhdHRyX29ubGluZSk7CisJc3lzZGV2X3VucmVn
aXN0ZXIoJnBjcHUtPnN5c2Rldik7CisJbGlzdF9kZWwoJnBjcHUtPnBjcHVfbGlzdCk7CisJa2Zy
ZWUocGNwdSk7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGlubGluZSBpbnQgc2FtZV9wY3B1
KHN0cnVjdCB4ZW5wZl9wY3B1aW5mbyAqaW5mbywKKwkJCSAgICBzdHJ1Y3QgcGNwdSAqcGNwdSkK
K3sKKwlyZXR1cm4gKHBjcHUtPmFwaWNfaWQgPT0gaW5mby0+YXBpY19pZCkgJiYKKwkJKHBjcHUt
Pnhlbl9pZCA9PSBpbmZvLT54ZW5fY3B1aWQpOworfQorCisvKgorICogUmV0dXJuIDEgaWYgb25s
aW5lIHN0YXR1cyBjaGFuZ2VkCisgKi8KK3N0YXRpYyBpbnQgeGVuX3BjcHVfb25saW5lX2NoZWNr
KHN0cnVjdCB4ZW5wZl9wY3B1aW5mbyAqaW5mbywKKwkJCQkgc3RydWN0IHBjcHUgKnBjcHUpCit7
CisJaW50IHJlc3VsdCA9IDA7CisKKwlpZiAoaW5mby0+eGVuX2NwdWlkICE9IHBjcHUtPnhlbl9p
ZCkKKwkJcmV0dXJuIDA7CisKKwlpZiAoeGVuX3BjcHVfb25saW5lKGluZm8tPmZsYWdzKSAmJiAh
eGVuX3BjcHVfb25saW5lKHBjcHUtPmZsYWdzKSkgeworCQkvKiB0aGUgcGNwdSBpcyBvbmxpbmVk
ICovCisJCXBjcHUtPmZsYWdzIHw9IFhFTl9QQ1BVX0ZMQUdTX09OTElORTsKKwkJa29iamVjdF91
ZXZlbnQoJnBjcHUtPnN5c2Rldi5rb2JqLCBLT0JKX09OTElORSk7CisJCXJhd19ub3RpZmllcl9j
YWxsX2NoYWluKCZ4ZW5fcGNwdV9jaGFpbiwKKwkJCVhFTl9QQ1BVX09OTElORSwgKHZvaWQgKiko
bG9uZylwY3B1LT54ZW5faWQpOworCQlyZXN1bHQgPSAxOworCX0gZWxzZSBpZiAoIXhlbl9wY3B1
X29ubGluZShpbmZvLT5mbGFncykgJiYKKwkJIHhlbl9wY3B1X29ubGluZShwY3B1LT5mbGFncykp
ICB7CisJCS8qIFRoZSBwY3B1IGlzIG9mZmxpbmVkIG5vdyAqLworCQlwY3B1LT5mbGFncyAmPSB+
WEVOX1BDUFVfRkxBR1NfT05MSU5FOworCQlrb2JqZWN0X3VldmVudCgmcGNwdS0+c3lzZGV2Lmtv
YmosIEtPQkpfT0ZGTElORSk7CisJCXJhd19ub3RpZmllcl9jYWxsX2NoYWluKCZ4ZW5fcGNwdV9j
aGFpbiwKKwkJCVhFTl9QQ1BVX09GRkxJTkUsICh2b2lkICopKGxvbmcpcGNwdS0+eGVuX2lkKTsK
KwkJcmVzdWx0ID0gMTsKKwl9CisKKwlyZXR1cm4gcmVzdWx0OworfQorCitzdGF0aWMgaW50IHBj
cHVfc3lzZGV2X2luaXQoc3RydWN0IHBjcHUgKmNwdSkKK3sKKwlpbnQgZXJyb3I7CisKKwllcnJv
ciA9IHN5c2Rldl9yZWdpc3RlcigmY3B1LT5zeXNkZXYpOworCWlmIChlcnJvcikgeworCQlwcmlu
dGsoS0VSTl9XQVJOSU5HICJ4ZW5fcGNwdV9hZGQ6IEZhaWxlZCB0byByZWdpc3RlciBwY3B1XG4i
KTsKKwkJa2ZyZWUoY3B1KTsKKwkJcmV0dXJuIC0xOworCX0KKwlzeXNkZXZfY3JlYXRlX2ZpbGUo
JmNwdS0+c3lzZGV2LCAmYXR0cl9vbmxpbmUpOworCXN5c2Rldl9jcmVhdGVfZmlsZSgmY3B1LT5z
eXNkZXYsICZhdHRyX2FwaWNfaWQpOworCXN5c2Rldl9jcmVhdGVfZmlsZSgmY3B1LT5zeXNkZXYs
ICZhdHRyX2FjcGlfaWQpOworCXJldHVybiAwOworfQorCitzdGF0aWMgc3RydWN0IHBjcHUgKmdl
dF9wY3B1KGludCB4ZW5faWQpCit7CisJc3RydWN0IHBjcHUgKnBjcHUgPSBOVUxMOworCisJbGlz
dF9mb3JfZWFjaF9lbnRyeShwY3B1LCAmeGVuX3BjcHVzLmxpc3QsIHBjcHVfbGlzdCkgeworCQlp
ZiAocGNwdS0+eGVuX2lkID09IHhlbl9pZCkKKwkJCXJldHVybiBwY3B1OworCX0KKwlyZXR1cm4g
TlVMTDsKK30KKworc3RhdGljIHN0cnVjdCBwY3B1ICppbml0X3BjcHUoc3RydWN0IHhlbnBmX3Bj
cHVpbmZvICppbmZvKQoreworCXN0cnVjdCBwY3B1ICpwY3B1OworCisJaWYgKGluZm8tPmZsYWdz
ICYgWEVOX1BDUFVfRkxBR1NfSU5WQUxJRCkKKwkJcmV0dXJuIE5VTEw7CisKKwkvKiBUaGUgUENQ
VSBpcyBqdXN0IGFkZGVkICovCisJcGNwdSA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBwY3B1KSwg
R0ZQX0tFUk5FTCk7CisJaWYgKCFwY3B1KQorCQlyZXR1cm4gTlVMTDsKKworCUlOSVRfTElTVF9I
RUFEKCZwY3B1LT5wY3B1X2xpc3QpOworCXBjcHUtPnhlbl9pZCA9IGluZm8tPnhlbl9jcHVpZDsK
KwlwY3B1LT5hcGljX2lkID0gaW5mby0+YXBpY19pZDsKKwlwY3B1LT5hY3BpX2lkID0gaW5mby0+
YWNwaV9pZDsKKwlwY3B1LT5mbGFncyA9IGluZm8tPmZsYWdzOworCisJcGNwdS0+c3lzZGV2LmNs
cyA9ICZ4ZW5fcGNwdV9zeXNkZXZfY2xhc3M7CisJcGNwdS0+c3lzZGV2LmlkID0gaW5mby0+eGVu
X2NwdWlkOworCisJaWYgKHBjcHVfc3lzZGV2X2luaXQocGNwdSkpIHsKKwkJa2ZyZWUocGNwdSk7
CisJCXJldHVybiBOVUxMOworCX0KKworCWxpc3RfYWRkX3RhaWwoJnBjcHUtPnBjcHVfbGlzdCwg
Jnhlbl9wY3B1cy5saXN0KTsKKwlyYXdfbm90aWZpZXJfY2FsbF9jaGFpbigmeGVuX3BjcHVfY2hh
aW4sCisJCQkJWEVOX1BDUFVfQURELAorCQkJCSh2b2lkICopKGxvbmcpcGNwdS0+eGVuX2lkKTsK
KwlyZXR1cm4gcGNwdTsKK30KKworI2RlZmluZSBQQ1BVX05PX0NIQU5HRQkJCTAKKyNkZWZpbmUg
UENQVV9BRERFRAkJCTEKKyNkZWZpbmUgUENQVV9PTkxJTkVfT0ZGTElORQkJMgorI2RlZmluZSBQ
Q1BVX1JFTU9WRUQJCQkzCisvKgorICogQ2FsbGVyIHNob3VsZCBob2xkIHRoZSBwY3B1IGxvY2sK
KyAqIDwgMDogU29tZXRoaW5nIHdyb25nCisgKiAwOiBObyBjaGFuZ2VzCisgKiA+IDA6IFN0YXRl
IGNoYW5nZWQKKyAqLworc3RhdGljIHN0cnVjdCBwY3B1ICpfc3luY19wY3B1KGludCBjcHVfbnVt
LCBpbnQgKm1heF9pZCwgaW50ICpyZXN1bHQpCit7CisJc3RydWN0IHBjcHUgKnBjcHUgPSBOVUxM
OworCXN0cnVjdCB4ZW5wZl9wY3B1aW5mbyAqaW5mbzsKKwl4ZW5fcGxhdGZvcm1fb3BfdCBvcCA9
IHsKKwkJLmNtZCAgICAgICAgICAgID0gWEVOUEZfZ2V0X2NwdWluZm8sCisJCS5pbnRlcmZhY2Vf
dmVyc2lvbiAgPSBYRU5QRl9JTlRFUkZBQ0VfVkVSU0lPTiwKKwl9OworCWludCByZXQ7CisKKwkq
cmVzdWx0ID0gLTE7CisKKwlpbmZvID0gJm9wLnUucGNwdV9pbmZvOworCWluZm8tPnhlbl9jcHVp
ZCA9IGNwdV9udW07CisKKwlyZXQgPSBIWVBFUlZJU09SX2RvbTBfb3AoJm9wKTsKKwlpZiAocmV0
KQorCQlyZXR1cm4gTlVMTDsKKworCWlmIChtYXhfaWQpCisJCSptYXhfaWQgPSBvcC51LnBjcHVf
aW5mby5tYXhfcHJlc2VudDsKKworCXBjcHUgPSBnZXRfcGNwdShjcHVfbnVtKTsKKworCWlmIChp
bmZvLT5mbGFncyAmIFhFTl9QQ1BVX0ZMQUdTX0lOVkFMSUQpIHsKKwkJLyogVGhlIHBjcHUgaGFz
IGJlZW4gcmVtb3ZlZCAqLworCQkqcmVzdWx0ID0gUENQVV9OT19DSEFOR0U7CisJCWlmIChwY3B1
KSB7CisJCQlyYXdfbm90aWZpZXJfY2FsbF9jaGFpbigmeGVuX3BjcHVfY2hhaW4sCisJCQkgIFhF
Tl9QQ1BVX1JFTU9WRSwKKwkJCSAgKHZvaWQgKikobG9uZylwY3B1LT54ZW5faWQpOworCQkJeGVu
X3BjcHVfZnJlZShwY3B1KTsKKwkJCSpyZXN1bHQgPSBQQ1BVX1JFTU9WRUQ7CisJCX0KKwkJcmV0
dXJuIE5VTEw7CisJfQorCisKKwlpZiAoIXBjcHUpIHsKKwkJKnJlc3VsdCA9IFBDUFVfQURERUQ7
CisJCXBjcHUgPSBpbml0X3BjcHUoaW5mbyk7CisJCWlmIChwY3B1ID09IE5VTEwpIHsKKwkJCXBy
aW50ayhLRVJOX1dBUk5JTkcgIkZhaWxlZCB0byBpbml0IHBjcHUgJXhcbiIsCisJCQkgIGluZm8t
Pnhlbl9jcHVpZCk7CisJCQkgICpyZXN1bHQgPSAtMTsKKwkJfQorCX0gZWxzZSB7CisJCSpyZXN1
bHQgPSBQQ1BVX05PX0NIQU5HRTsKKwkJLyoKKwkJICogT2xkIFBDUFUgaXMgcmVwbGFjZWQgd2l0
aCBhIG5ldyBwY3B1LCB0aGlzIG1lYW5zCisJCSAqIHNldmVyYWwgdmlycSBpcyBtaXNzZWQsIHdp
bGwgaXQgaGFwcGVuPworCQkgKi8KKwkJaWYgKCFzYW1lX3BjcHUoaW5mbywgcGNwdSkpIHsKKwkJ
CXByaW50ayhLRVJOX1dBUk5JTkcgIlBjcHUgJXggY2hhbmdlZCFcbiIsCisJCQkgIHBjcHUtPnhl
bl9pZCk7CisJCQlwY3B1LT5hcGljX2lkID0gaW5mby0+YXBpY19pZDsKKwkJCXBjcHUtPmFjcGlf
aWQgPSBpbmZvLT5hY3BpX2lkOworCQl9CisJCWlmICh4ZW5fcGNwdV9vbmxpbmVfY2hlY2soaW5m
bywgcGNwdSkpCisJCQkqcmVzdWx0ID0gUENQVV9PTkxJTkVfT0ZGTElORTsKKwl9CisJcmV0dXJu
IHBjcHU7Cit9CisKK2ludCB4ZW5fcGNwdV9pbmRleCh1aW50MzJfdCBpZCwgaW50IGlzX2FjcGlp
ZCkKK3sKKwlpbnQgY3B1X251bSA9IDAsIG1heF9pZCA9IDAsIHJldDsKKwl4ZW5fcGxhdGZvcm1f
b3BfdCBvcCA9IHsKKwkJLmNtZCAgICAgICAgICAgID0gWEVOUEZfZ2V0X2NwdWluZm8sCisJCS5p
bnRlcmZhY2VfdmVyc2lvbiAgPSBYRU5QRl9JTlRFUkZBQ0VfVkVSU0lPTiwKKwl9OworCXN0cnVj
dCB4ZW5wZl9wY3B1aW5mbyAqaW5mbyA9ICZvcC51LnBjcHVfaW5mbzsKKworCWluZm8tPnhlbl9j
cHVpZCA9IDA7CisJcmV0ID0gSFlQRVJWSVNPUl9kb20wX29wKCZvcCk7CisJaWYgKHJldCkKKwkJ
cmV0dXJuIC0xOworCW1heF9pZCA9IG9wLnUucGNwdV9pbmZvLm1heF9wcmVzZW50OworCisJd2hp
bGUgKChjcHVfbnVtIDw9IG1heF9pZCkpIHsKKwkJaW5mby0+eGVuX2NwdWlkID0gY3B1X251bTsK
KwkJcmV0ID0gSFlQRVJWSVNPUl9kb20wX29wKCZvcCk7CisJCWlmIChyZXQpCisJCQljb250aW51
ZTsKKworCQlpZiAob3AudS5wY3B1X2luZm8ubWF4X3ByZXNlbnQgPiBtYXhfaWQpCisJCQltYXhf
aWQgPSBvcC51LnBjcHVfaW5mby5tYXhfcHJlc2VudDsKKwkJaWYgKGlkID09IChpc19hY3BpaWQg
PyBpbmZvLT5hY3BpX2lkIDogaW5mby0+YXBpY19pZCkpCisJCQlyZXR1cm4gY3B1X251bTsKKwkJ
Y3B1X251bSsrOworCX0KKworICAgIHJldHVybiAtMTsKK30KK0VYUE9SVF9TWU1CT0woeGVuX3Bj
cHVfaW5kZXgpOworCisvKgorICogU3luYyBkb20wJ3MgcGNwdSBpbmZvcm1hdGlvbiB3aXRoIHhl
biBoeXBlcnZpc29yJ3MKKyAqLworc3RhdGljIGludCB4ZW5fc3luY19wY3B1cyh2b2lkKQorewor
CS8qCisJICogQm9vdCBjcHUgYWx3YXlzIGhhdmUgY3B1X2lkIDAgaW4geGVuCisJICovCisJaW50
IGNwdV9udW0gPSAwLCBtYXhfaWQgPSAwLCByZXN1bHQgPSAwLCBwcmVzZW50ID0gMDsKKwlzdHJ1
Y3QgbGlzdF9oZWFkICplbGVtLCAqdG1wOworCXN0cnVjdCBwY3B1ICpwY3B1OworCisJZ2V0X3Bj
cHVfbG9jaygpOworCisJd2hpbGUgKChyZXN1bHQgPj0gMCkgJiYgKGNwdV9udW0gPD0gbWF4X2lk
KSkgeworCQlwY3B1ID0gX3N5bmNfcGNwdShjcHVfbnVtLCAmbWF4X2lkLCAmcmVzdWx0KTsKKwor
CQlwcmludGsoS0VSTl9ERUJVRyAic3luYyBjcHUgJXggZ2V0IHJlc3VsdCAleCBtYXhfaWQgJXhc
biIsCisJCQljcHVfbnVtLCByZXN1bHQsIG1heF9pZCk7CisKKwkJc3dpdGNoIChyZXN1bHQpCXsK
KwkJY2FzZSBQQ1BVX05PX0NIQU5HRToKKwkJCWlmIChwY3B1KQorCQkJCXByZXNlbnQrKzsKKwkJ
CWJyZWFrOworCQljYXNlIFBDUFVfQURERUQ6CisJCWNhc2UgUENQVV9PTkxJTkVfT0ZGTElORToK
KwkJCXByZXNlbnQrKzsKKwkJY2FzZSBQQ1BVX1JFTU9WRUQ6CisJCQlicmVhazsKKwkJZGVmYXVs
dDoKKwkJCXByaW50ayhLRVJOX1dBUk5JTkcgIkZhaWxlZCB0byBzeW5jIHBjcHUgJXhcbiIsCisJ
CQkgIGNwdV9udW0pOworCQkJYnJlYWs7CisKKwkJfQorCQljcHVfbnVtKys7CisJfQorCisJaWYg
KHJlc3VsdCA8IDApIHsKKwkJbGlzdF9mb3JfZWFjaF9zYWZlKGVsZW0sIHRtcCwgJnhlbl9wY3B1
cy5saXN0KSB7CisJCQlwY3B1ID0gbGlzdF9lbnRyeShlbGVtLCBzdHJ1Y3QgcGNwdSwgcGNwdV9s
aXN0KTsKKwkJCXhlbl9wY3B1X2ZyZWUocGNwdSk7CisJCX0KKwkJcHJlc2VudCA9IDA7CisJfQor
CisJeGVuX3BjcHVzLnByZXNlbnQgPSBwcmVzZW50OworCisJcHV0X3BjcHVfbG9jaygpOworCisJ
cmV0dXJuIDA7Cit9CisKK3N0YXRpYyB2b2lkIHhlbl9wY3B1X2RwYyhzdHJ1Y3Qgd29ya19zdHJ1
Y3QgKndvcmspCit7CisJaWYgKHhlbl9zeW5jX3BjcHVzKCkgPCAwKQorCQlwcmludGsoS0VSTl9X
QVJOSU5HCisJCQkieGVuX3BjcHVfZHBjOiBGYWlsZWQgdG8gc3luYyBwY3B1IGluZm9ybWF0aW9u
XG4iKTsKK30KK3N0YXRpYyBERUNMQVJFX1dPUksoeGVuX3BjcHVfd29yaywgeGVuX3BjcHVfZHBj
KTsKKworaW50IHhlbl9wY3B1X2hvdHBsdWcoaW50IHR5cGUsIHVpbnQzMl90IGFwaWNfaWQpCit7
CisJc2NoZWR1bGVfd29yaygmeGVuX3BjcHVfd29yayk7CisKKwlyZXR1cm4gMDsKK30KK0VYUE9S
VF9TWU1CT0woeGVuX3BjcHVfaG90cGx1Zyk7CisKK3N0YXRpYyBpcnFyZXR1cm5fdCB4ZW5fcGNw
dV9pbnRlcnJ1cHQoaW50IGlycSwgdm9pZCAqZGV2X2lkKQoreworCXNjaGVkdWxlX3dvcmsoJnhl
bl9wY3B1X3dvcmspOworCXJldHVybiBJUlFfSEFORExFRDsKK30KKworc3RhdGljIGludCBfX2lu
aXQgeGVuX3BjcHVfaW5pdCh2b2lkKQoreworCWludCBlcnI7CisKKwlpZiAoIXhlbl9pbml0aWFs
X2RvbWFpbigpKQorCQlyZXR1cm4gMDsKKworCWVyciA9IHN5c2Rldl9jbGFzc19yZWdpc3Rlcigm
eGVuX3BjcHVfc3lzZGV2X2NsYXNzKTsKKwlpZiAoZXJyKSB7CisJCXByaW50ayhLRVJOX1dBUk5J
TkcKKwkJCSJ4ZW5fcGNwdV9pbml0OiByZWdpc3RlciB4ZW5fcGNwdSBzeXNkZXYgRmFpbGVkIVxu
Iik7CisJCXJldHVybiBlcnI7CisJfQorCisJSU5JVF9MSVNUX0hFQUQoJnhlbl9wY3B1cy5saXN0
KTsKKwl4ZW5fcGNwdXMucHJlc2VudCA9IDA7CisKKwl4ZW5fc3luY19wY3B1cygpOworCWlmICh4
ZW5fcGNwdXMucHJlc2VudCA+IDApCisJCWVyciA9IGJpbmRfdmlycV90b19pcnFoYW5kbGVyKFZJ
UlFfUENQVV9TVEFURSwKKwkJCTAsIHhlbl9wY3B1X2ludGVycnVwdCwgMCwgInBjcHUiLCBOVUxM
KTsKKwlpZiAoZXJyIDwgMCkKKwkJcHJpbnRrKEtFUk5fV0FSTklORyAieGVuX3BjcHVfaW5pdDog
IgorCQkJIkZhaWxlZCB0byBiaW5kIHBjcHVfc3RhdGUgdmlycVxuIgorCQkJIllvdSB3aWxsIGxv
c3QgbGF0ZXN0IGluZm9ybWF0aW9uISBcbiIpOworCXJldHVybiBlcnI7Cit9CisKK2FyY2hfaW5p
dGNhbGwoeGVuX3BjcHVfaW5pdCk7CmRpZmYgLS1naXQgYS9pbmNsdWRlL3hlbi9pbnRlcmZhY2Uv
cGxhdGZvcm0uaCBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oCmluZGV4IGMxNjg0
NjguLjQ3ZmZlMTYgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5o
CisrKyBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oCkBAIC0yOTcsNiArMjk3LDMx
IEBAIHN0cnVjdCB4ZW5wZl9zZXRfcHJvY2Vzc29yX3BtaW5mbyB7CiB9OwogREVGSU5FX0dVRVNU
X0hBTkRMRV9TVFJVQ1QoeGVucGZfc2V0X3Byb2Nlc3Nvcl9wbWluZm8pOwogCisjZGVmaW5lIFhF
TlBGX2dldF9jcHVpbmZvIDU1CitzdHJ1Y3QgeGVucGZfcGNwdWluZm8geworCS8qIElOICovCisJ
dWludDMyX3QgeGVuX2NwdWlkOworCS8qIE9VVCAqLworCS8qIFRoZSBtYXhpdW0gY3B1X2lkIHRo
YXQgaXMgcHJlc2VudCAqLworCXVpbnQzMl90IG1heF9wcmVzZW50OworI2RlZmluZSBYRU5fUENQ
VV9GTEFHU19PTkxJTkUgICAxCisJLyogQ29ycmVwb25kaW5nIHhlbl9jcHVpZCBpcyBub3QgcHJl
c2VudCovCisjZGVmaW5lIFhFTl9QQ1BVX0ZMQUdTX0lOVkFMSUQgIDIKKwl1aW50MzJfdCBmbGFn
czsKKwl1aW50MzJfdCBhcGljX2lkOworCXVpbnQzMl90IGFjcGlfaWQ7Cit9OwordHlwZWRlZiBz
dHJ1Y3QgeGVucGZfcGNwdWluZm8geGVucGZfcGNwdWluZm9fdDsKK0RFRklORV9HVUVTVF9IQU5E
TEVfU1RSVUNUKHhlbnBmX3BjcHVpbmZvX3QpOworCisjZGVmaW5lIFhFTlBGX2NwdV9vbmxpbmUg
ICAgNTYKKyNkZWZpbmUgWEVOUEZfY3B1X29mZmxpbmUgICA1Nworc3RydWN0IHhlbnBmX2NwdV9v
bCB7CisgICAgdWludDMyX3QgY3B1aWQ7Cit9OwordHlwZWRlZiBzdHJ1Y3QgeGVucGZfY3B1X29s
IHhlbnBmX2NwdV9vbF90OworREVGSU5FX0dVRVNUX0hBTkRMRV9TVFJVQ1QoeGVucGZfY3B1X29s
X3QpOworCiBzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wIHsKIAl1aW50MzJfdCBjbWQ7CiAJdWludDMy
X3QgaW50ZXJmYWNlX3ZlcnNpb247IC8qIFhFTlBGX0lOVEVSRkFDRV9WRVJTSU9OICovCkBAIC0z
MTIsOSArMzM3LDEyIEBAIHN0cnVjdCB4ZW5fcGxhdGZvcm1fb3AgewogCQlzdHJ1Y3QgeGVucGZf
Y2hhbmdlX2ZyZXEgICAgICAgY2hhbmdlX2ZyZXE7CiAJCXN0cnVjdCB4ZW5wZl9nZXRpZGxldGlt
ZSAgICAgICBnZXRpZGxldGltZTsKIAkJc3RydWN0IHhlbnBmX3NldF9wcm9jZXNzb3JfcG1pbmZv
IHNldF9wbWluZm87CisJCXN0cnVjdCB4ZW5wZl9wY3B1aW5mbyAgICAgICAgICBwY3B1X2luZm87
CisJCXN0cnVjdCB4ZW5wZl9jcHVfb2wgICAgICAgICAgICBjcHVfb2w7CiAJCXVpbnQ4X3QgICAg
ICAgICAgICAgICAgICAgICAgICBwYWRbMTI4XTsKIAl9IHU7CiB9OwordHlwZWRlZiBzdHJ1Y3Qg
eGVuX3BsYXRmb3JtX29wIHhlbl9wbGF0Zm9ybV9vcF90OwogREVGSU5FX0dVRVNUX0hBTkRMRV9T
VFJVQ1QoeGVuX3BsYXRmb3JtX29wX3QpOwogCiAjZW5kaWYgLyogX19YRU5fUFVCTElDX1BMQVRG
T1JNX0hfXyAqLwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3hlbi5oIGIvaW5j
bHVkZS94ZW4vaW50ZXJmYWNlL3hlbi5oCmluZGV4IDZhNmU5MTQuLjVhOTFjNjYgMTAwNjQ0Ci0t
LSBhL2luY2x1ZGUveGVuL2ludGVyZmFjZS94ZW4uaAorKysgYi9pbmNsdWRlL3hlbi9pbnRlcmZh
Y2UveGVuLmgKQEAgLTgwLDYgKzgwLDcgQEAKICNkZWZpbmUgVklSUV9DT05TT0xFICAgIDIgIC8q
IChET00wKSBCeXRlcyByZWNlaXZlZCBvbiBlbWVyZ2VuY3kgY29uc29sZS4gKi8KICNkZWZpbmUg
VklSUV9ET01fRVhDICAgIDMgIC8qIChET00wKSBFeGNlcHRpb25hbCBldmVudCBmb3Igc29tZSBk
b21haW4uICAgKi8KICNkZWZpbmUgVklSUV9ERUJVR0dFUiAgIDYgIC8qIChET00wKSBBIGRvbWFp
biBoYXMgcGF1c2VkIGZvciBkZWJ1Z2dpbmcuICAgKi8KKyNkZWZpbmUgVklSUV9QQ1BVX1NUQVRF
IDkgIC8qIChET00wKSBQQ1BVIHN0YXRlIGNoYW5nZWQgICAgICAgICAgICAgICAgICAgKi8KIAog
LyogQXJjaGl0ZWN0dXJlLXNwZWNpZmljIFZJUlEgZGVmaW5pdGlvbnMuICovCiAjZGVmaW5lIFZJ
UlFfQVJDSF8wICAgIDE2CmRpZmYgLS1naXQgYS9pbmNsdWRlL3hlbi9wY3B1LmggYi9pbmNsdWRl
L3hlbi9wY3B1LmgKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uN2U4ZjlkMQot
LS0gL2Rldi9udWxsCisrKyBiL2luY2x1ZGUveGVuL3BjcHUuaApAQCAtMCwwICsxLDMyIEBACisj
aWZuZGVmIF9YRU5fUENQVV9ICisjZGVmaW5lIF9YRU5fUENQVV9ICisKKyNpbmNsdWRlIDx4ZW4v
aW50ZXJmYWNlL3BsYXRmb3JtLmg+CisjaW5jbHVkZSA8bGludXgvc3lzZGV2Lmg+CisKK2V4dGVy
biBpbnQgeGVuX3BjcHVfaG90cGx1ZyhpbnQgdHlwZSwgdWludDMyX3QgYXBpY19pZCk7CisjZGVm
aW5lIFhFTl9QQ1BVX09OTElORSAgICAgMHgwMQorI2RlZmluZSBYRU5fUENQVV9PRkZMSU5FICAg
IDB4MDIKKyNkZWZpbmUgWEVOX1BDUFVfQUREICAgICAgICAweDA0CisjZGVmaW5lIFhFTl9QQ1BV
X1JFTU9WRSAgICAgMHgwOAorCitzdHJ1Y3QgcGNwdSB7CisJc3RydWN0IGxpc3RfaGVhZCBwY3B1
X2xpc3Q7CisJc3RydWN0IHN5c19kZXZpY2Ugc3lzZGV2OworCXVpbnQzMl90IHhlbl9pZDsKKwl1
aW50MzJfdCBhcGljX2lkOworCXVpbnQzMl90IGFjcGlfaWQ7CisJdWludDMyX3QgZmxhZ3M7Cit9
OworCitzdGF0aWMgaW5saW5lIGludCB4ZW5fcGNwdV9vbmxpbmUodWludDMyX3QgZmxhZ3MpCit7
CisJcmV0dXJuICEhKGZsYWdzICYgWEVOX1BDUFVfRkxBR1NfT05MSU5FKTsKK30KKworZXh0ZXJu
IGludCByZWdpc3Rlcl94ZW5fcGNwdV9ub3RpZmllcihzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5i
KTsKKworZXh0ZXJuIHZvaWQgdW5yZWdpc3Rlcl94ZW5fcGNwdV9ub3RpZmllcihzdHJ1Y3Qgbm90
aWZpZXJfYmxvY2sgKm5iKTsKKworZXh0ZXJuIGludCB4ZW5fcGNwdV9pbmRleCh1aW50MzJfdCBh
Y3BpX2lkLCBpbnQgaXNfYWNwaWlkKTsKKyNlbmRpZgotLSAKMS42LjUuNgoK

--_002_DE8DF0795D48FD4CA783C40EC829233596CCSHSMSX101ccrcorpint_--
