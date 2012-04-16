Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab2DPBGB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 21:06:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:50249 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab2DPBGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 21:06:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="131240617"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] Add mcelog support for xen platform
Thread-Topic: [PATCH 1/2] Add mcelog support for xen platform
Thread-Index: Ac0bbRNQOwwDTGvoRgyQnQsEo/DLwA==
Date: Mon, 16 Apr 2012 01:05:55 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335146A62@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC8292335146A62SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC8292335146A62SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 0ee0651756eb6255bc81da8a7b6313bab4b80d1e Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Sun, 15 Apr 2012 22:58:34 +0800
Subject: [PATCH 1/2] Add mcelog support for xen platform

When MCA error occurs, it would be handled by xen hypervisor first,
and then the error information would be sent to dom0 for logging.

This patch gets error information from xen hypervisor and convert
xen format error into linux format mcelog. This logic is basically
self-contained, not much touching other kernel components.

So under xen platform when MCA error occurs, the error information
would be sent to dom0 and converted into native linux mcelog format.
By using tools like mcelog tool users could read specific error information=
,
like what they did under native linux.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
Signed-off-by: Ke, Liping <liping.ke@intel.com>
Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/xen/hypercall.h |    8 +
 arch/x86/xen/enlighten.c             |    4 +-
 drivers/xen/Kconfig                  |    8 +
 drivers/xen/Makefile                 |    1 +
 drivers/xen/mcelog.c                 |  201 ++++++++++++++++++++
 include/xen/interface/xen-mca.h      |  336 ++++++++++++++++++++++++++++++=
++++
 6 files changed, 555 insertions(+), 3 deletions(-)
 create mode 100644 drivers/xen/mcelog.c
 create mode 100644 include/xen/interface/xen-mca.h

diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xe=
n/hypercall.h
index 5728852..59c226d 100644
--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -48,6 +48,7 @@
 #include <xen/interface/sched.h>
 #include <xen/interface/physdev.h>
 #include <xen/interface/platform.h>
+#include <xen/interface/xen-mca.h>
=20
 /*
  * The hypercall asms have to meet several constraints:
@@ -302,6 +303,13 @@ HYPERVISOR_set_timer_op(u64 timeout)
 }
=20
 static inline int
+HYPERVISOR_mca(struct xen_mc *mc_op)
+{
+	mc_op->interface_version =3D XEN_MCA_INTERFACE_VERSION;
+	return _hypercall1(int, mca, mc_op);
+}
+
+static inline int
 HYPERVISOR_dom0_op(struct xen_platform_op *platform_op)
 {
 	platform_op->interface_version =3D XENPF_INTERFACE_VERSION;
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 4f51beb..15628d4 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -329,9 +329,7 @@ static void __init xen_init_cpuid_mask(void)
 	unsigned int xsave_mask;
=20
 	cpuid_leaf1_edx_mask =3D
-		~((1 << X86_FEATURE_MCE)  |  /* disable MCE */
-		  (1 << X86_FEATURE_MCA)  |  /* disable MCA */
-		  (1 << X86_FEATURE_MTRR) |  /* disable MTRR */
+		~((1 << X86_FEATURE_MTRR) |  /* disable MTRR */
 		  (1 << X86_FEATURE_ACC));   /* thermal monitoring */
=20
 	if (!xen_initial_domain())
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 9424313..f45f923 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -194,4 +194,12 @@ config XEN_ACPI_PROCESSOR
           module will be called xen_acpi_processor  If you do not know wha=
t to choose,
           select M here. If the CPUFREQ drivers are built in, select Y her=
e.
=20
+config XEN_MCE_LOG
+	bool "Xen platform mcelog"
+	depends on XEN_DOM0 && X86_64 && X86_MCE
+	default n
+	help
+	  Allow kernel fetching mce log from xen platform and
+	  converting it into linux mcelog format for mcelog tools
+
 endmenu
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 9adc5be..1d3e763 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_XEN_GNTDEV)		+=3D xen-gntdev.o
 obj-$(CONFIG_XEN_GRANT_DEV_ALLOC)	+=3D xen-gntalloc.o
 obj-$(CONFIG_XENFS)			+=3D xenfs/
 obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+=3D sys-hypervisor.o
+obj-$(CONFIG_XEN_MCE_LOG)		+=3D mcelog.o
 obj-$(CONFIG_XEN_PVHVM)			+=3D platform-pci.o
 obj-$(CONFIG_XEN_TMEM)			+=3D tmem.o
 obj-$(CONFIG_SWIOTLB_XEN)		+=3D swiotlb-xen.o
diff --git a/drivers/xen/mcelog.c b/drivers/xen/mcelog.c
new file mode 100644
index 0000000..e9f86b8
--- /dev/null
+++ b/drivers/xen/mcelog.c
@@ -0,0 +1,201 @@
+/*************************************************************************=
*****
+ * mcelog.c
+ * Driver for receiving and transferring machine check error infomation
+ *
+ * Copyright (c) 2012 Intel Corporation
+ * Author: Liu, Jinsong <jinsong.liu@intel.com>
+ * Author: Jiang, Yunhong <yunhong.jiang@intel.com>
+ * Author: Ke, Liping <liping.ke@intel.com>
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
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <xen/interface/xen.h>
+#include <asm/xen/hypervisor.h>
+#include <xen/events.h>
+#include <xen/interface/vcpu.h>
+#include <asm/xen/hypercall.h>
+#include <asm/mce.h>
+#include <xen/xen.h>
+
+static struct mc_info g_mi;
+static struct mcinfo_logical_cpu *g_physinfo;
+static uint32_t ncpus;
+
+static DEFINE_SPINLOCK(mcelog_lock);
+
+static void convert_log(struct mc_info *mi)
+{
+	struct mcinfo_common *mic;
+	struct mcinfo_global *mc_global;
+	struct mcinfo_bank *mc_bank;
+	struct mce m;
+	int i;
+
+	mic =3D NULL;
+	x86_mcinfo_lookup(&mic, mi, MC_TYPE_GLOBAL);
+	if (unlikely(!mic))
+		return;
+
+	mce_setup(&m);
+	mc_global =3D (struct mcinfo_global *)mic;
+	m.mcgstatus =3D mc_global->mc_gstatus;
+	m.apicid =3D mc_global->mc_apicid;
+
+	for (i =3D 0; i < ncpus; i++)
+		if (g_physinfo[i].mc_apicid =3D=3D m.apicid)
+			break;
+	if (unlikely(i =3D=3D ncpus))
+		return;
+
+	m.socketid =3D g_physinfo[i].mc_chipid;
+	m.cpu =3D m.extcpu =3D g_physinfo[i].mc_cpunr;
+	m.cpuvendor =3D (__u8)g_physinfo[i].mc_vendor;
+	m.mcgcap =3D g_physinfo[i].mc_msrvalues[__MC_MSR_MCGCAP].value;
+
+	mic =3D NULL;
+	x86_mcinfo_lookup(&mic, mi, MC_TYPE_BANK);
+
+	do {
+		if ((!mic) || (mic->size =3D=3D 0) ||
+		    (mic->type !=3D MC_TYPE_GLOBAL   &&
+		     mic->type !=3D MC_TYPE_BANK     &&
+		     mic->type !=3D MC_TYPE_EXTENDED &&
+		     mic->type !=3D MC_TYPE_RECOVERY))
+			break;
+
+		if (mic->type =3D=3D MC_TYPE_BANK) {
+			mc_bank =3D (struct mcinfo_bank *)mic;
+			m.misc =3D mc_bank->mc_misc;
+			m.status =3D mc_bank->mc_status;
+			m.addr =3D mc_bank->mc_addr;
+			m.tsc =3D mc_bank->mc_tsc;
+			m.bank =3D mc_bank->mc_bank;
+			m.finished =3D 1;
+			/*log this record*/
+			mce_log(&m);
+		}
+		mic =3D x86_mcinfo_next(mic);
+	} while (1);
+}
+
+static void mc_queue_handle(uint32_t flags)
+{
+	struct xen_mc mc_op;
+	int ret =3D 0;
+	unsigned long tmp;
+
+	spin_lock_irqsave(&mcelog_lock, tmp);
+
+	mc_op.cmd =3D XEN_MC_fetch;
+	mc_op.interface_version =3D XEN_MCA_INTERFACE_VERSION;
+	set_xen_guest_handle(mc_op.u.mc_fetch.data, &g_mi);
+	do {
+		mc_op.u.mc_fetch.flags =3D flags;
+		ret =3D HYPERVISOR_mca(&mc_op);
+		if (ret || mc_op.u.mc_fetch.flags & XEN_MC_NODATA ||
+		    mc_op.u.mc_fetch.flags & XEN_MC_FETCHFAILED)
+			break;
+		else {
+			convert_log(&g_mi);
+			mc_op.u.mc_fetch.flags =3D flags | XEN_MC_ACK;
+			ret =3D HYPERVISOR_mca(&mc_op);
+			if (ret)
+				break;
+		}
+	} while (1);
+
+	spin_unlock_irqrestore(&mcelog_lock, tmp);
+
+	return;
+}
+
+/* virq handler for machine check error info*/
+static irqreturn_t mce_dom_interrupt(int irq, void *dev_id)
+{
+	/* urgent mc_info */
+	mc_queue_handle(XEN_MC_URGENT);
+
+	/* nonurgent mc_info */
+	mc_queue_handle(XEN_MC_NONURGENT);
+
+	return IRQ_HANDLED;
+}
+
+static int bind_virq_for_mce(void)
+{
+	int ret;
+	struct xen_mc mc_op;
+
+	memset(&mc_op, 0, sizeof(struct xen_mc));
+
+	/* Fetch physical CPU Numbers */
+	mc_op.cmd =3D XEN_MC_physcpuinfo;
+	mc_op.interface_version =3D XEN_MCA_INTERFACE_VERSION;
+	set_xen_guest_handle(mc_op.u.mc_physcpuinfo.info, g_physinfo);
+	ret =3D HYPERVISOR_mca(&mc_op);
+	if (ret) {
+		printk(KERN_ERR "MCE_LOG: Failed to get CPU numbers\n");
+		return ret;
+	}
+
+	/* Fetch each CPU Physical Info for later reference*/
+	ncpus =3D mc_op.u.mc_physcpuinfo.ncpus;
+	g_physinfo =3D kzalloc(sizeof(struct mcinfo_logical_cpu) * ncpus,
+			     GFP_KERNEL);
+	if (!g_physinfo)
+		return -ENOMEM;
+	set_xen_guest_handle(mc_op.u.mc_physcpuinfo.info, g_physinfo);
+	ret =3D HYPERVISOR_mca(&mc_op);
+	if (ret) {
+		printk(KERN_ERR "MCE_LOG: Failed to get CPU info\n");
+		kfree(g_physinfo);
+		return ret;
+	}
+
+	ret  =3D bind_virq_to_irqhandler(VIRQ_MCA, 0,
+				       mce_dom_interrupt, 0, "mce", NULL);
+	if (ret < 0) {
+		printk(KERN_ERR "MCE_LOG: Failed to bind virq\n");
+		kfree(g_physinfo);
+	}
+
+	return ret;
+}
+
+static int __init mcelog_init(void)
+{
+	/* Only DOM0 is responsible for MCE logging */
+	if (xen_initial_domain())
+		return bind_virq_for_mce();
+
+	return -ENODEV;
+}
+late_initcall(mcelog_init);
diff --git a/include/xen/interface/xen-mca.h b/include/xen/interface/xen-mc=
a.h
new file mode 100644
index 0000000..f2561db
--- /dev/null
+++ b/include/xen/interface/xen-mca.h
@@ -0,0 +1,336 @@
+/*************************************************************************=
*****
+ * arch-x86/mca.h
+ * Guest OS machine check interface to x86 Xen.
+ *
+ * Contributed by Advanced Micro Devices, Inc.
+ * Author: Christoph Egger <Christoph.Egger@amd.com>
+ *
+ * Updated by Intel Corporation
+ * Author: Liu, Jinsong <jinsong.liu@intel.com>
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a=
 copy
+ * of this software and associated documentation files (the "Software"), t=
o
+ * deal in the Software without restriction, including without limitation =
the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, an=
d/or
+ * sell copies of the Software, and to permit persons to whom the Software=
 is
+ * furnished to do so, subject to the following conditions:
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
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef __XEN_PUBLIC_ARCH_X86_MCA_H__
+#define __XEN_PUBLIC_ARCH_X86_MCA_H__
+
+/* Hypercall */
+#define __HYPERVISOR_mca __HYPERVISOR_arch_0
+
+#define XEN_MCA_INTERFACE_VERSION	0x01ecc003
+
+/* IN: Dom0 calls hypercall to retrieve nonurgent error log entry */
+#define XEN_MC_NONURGENT	0x1
+/* IN: Dom0 calls hypercall to retrieve urgent error log entry */
+#define XEN_MC_URGENT		0x2
+/* IN: Dom0 acknowledges previosly-fetched error log entry */
+#define XEN_MC_ACK		0x4
+
+/* OUT: All is ok */
+#define XEN_MC_OK		0x0
+/* OUT: Domain could not fetch data. */
+#define XEN_MC_FETCHFAILED	0x1
+/* OUT: There was no machine check data to fetch. */
+#define XEN_MC_NODATA		0x2
+
+#ifndef __ASSEMBLY__
+/* vIRQ injected to Dom0 */
+#define VIRQ_MCA VIRQ_ARCH_0
+
+/*
+ * mc_info entry types
+ * mca machine check info are recorded in mc_info entries.
+ * when fetch mca info, it can use MC_TYPE_... to distinguish
+ * different mca info.
+ */
+#define MC_TYPE_GLOBAL		0
+#define MC_TYPE_BANK		1
+#define MC_TYPE_EXTENDED	2
+#define MC_TYPE_RECOVERY	3
+
+struct mcinfo_common {
+	uint16_t type; /* structure type */
+	uint16_t size; /* size of this struct in bytes */
+};
+
+#define MC_FLAG_CORRECTABLE	(1 << 0)
+#define MC_FLAG_UNCORRECTABLE	(1 << 1)
+#define MC_FLAG_RECOVERABLE	(1 << 2)
+#define MC_FLAG_POLLED		(1 << 3)
+#define MC_FLAG_RESET		(1 << 4)
+#define MC_FLAG_CMCI		(1 << 5)
+#define MC_FLAG_MCE		(1 << 6)
+
+/* contains x86 global mc information */
+struct mcinfo_global {
+	struct mcinfo_common common;
+
+	uint16_t mc_domid; /* running domain at the time in error */
+	uint16_t mc_vcpuid; /* virtual cpu scheduled for mc_domid */
+	uint32_t mc_socketid; /* physical socket of the physical core */
+	uint16_t mc_coreid; /* physical impacted core */
+	uint16_t mc_core_threadid; /* core thread of physical core */
+	uint32_t mc_apicid;
+	uint32_t mc_flags;
+	uint64_t mc_gstatus; /* global status */
+};
+
+/* contains x86 bank mc information */
+struct mcinfo_bank {
+	struct mcinfo_common common;
+
+	uint16_t mc_bank; /* bank nr */
+	uint16_t mc_domid; /* domain referenced by mc_addr if valid */
+	uint64_t mc_status; /* bank status */
+	uint64_t mc_addr; /* bank address */
+	uint64_t mc_misc;
+	uint64_t mc_ctrl2;
+	uint64_t mc_tsc;
+};
+
+struct mcinfo_msr {
+	uint64_t reg; /* MSR */
+	uint64_t value; /* MSR value */
+};
+
+/* contains mc information from other or additional mc MSRs */
+struct mcinfo_extended {
+	struct mcinfo_common common;
+	uint32_t mc_msrs; /* Number of msr with valid values. */
+	/*
+	 * Currently Intel extended MSR (32/64) include all gp registers
+	 * and E(R)FLAGS, E(R)IP, E(R)MISC, up to 11/19 of them might be
+	 * useful at present. So expand this array to 16/32 to leave room.
+	 */
+	struct mcinfo_msr mc_msr[sizeof(void *) * 4];
+};
+
+/* Recovery Action flags. Giving recovery result information to DOM0 */
+
+/* Xen takes successful recovery action, the error is recovered */
+#define REC_ACTION_RECOVERED (0x1 << 0)
+/* No action is performed by XEN */
+#define REC_ACTION_NONE (0x1 << 1)
+/* It's possible DOM0 might take action ownership in some case */
+#define REC_ACTION_NEED_RESET (0x1 << 2)
+
+/*
+ * Different Recovery Action types, if the action is performed successfull=
y,
+ * REC_ACTION_RECOVERED flag will be returned.
+ */
+
+/* Page Offline Action */
+#define MC_ACTION_PAGE_OFFLINE (0x1 << 0)
+/* CPU offline Action */
+#define MC_ACTION_CPU_OFFLINE (0x1 << 1)
+/* L3 cache disable Action */
+#define MC_ACTION_CACHE_SHRINK (0x1 << 2)
+
+/*
+ * Below interface used between XEN/DOM0 for passing XEN's recovery action
+ * information to DOM0.
+ */
+struct page_offline_action {
+	/* Params for passing the offlined page number to DOM0 */
+	uint64_t mfn;
+	uint64_t status;
+};
+
+struct cpu_offline_action {
+	/* Params for passing the identity of the offlined CPU to DOM0 */
+	uint32_t mc_socketid;
+	uint16_t mc_coreid;
+	uint16_t mc_core_threadid;
+};
+
+#define MAX_UNION_SIZE 16
+struct mcinfo_recovery {
+	struct mcinfo_common common;
+	uint16_t mc_bank; /* bank nr */
+	uint8_t action_flags;
+	uint8_t action_types;
+	union {
+		struct page_offline_action page_retire;
+		struct cpu_offline_action cpu_offline;
+		uint8_t pad[MAX_UNION_SIZE];
+	} action_info;
+};
+
+
+#define MCINFO_MAXSIZE 768
+struct mc_info {
+	/* Number of mcinfo_* entries in mi_data */
+	uint32_t mi_nentries;
+	uint32_t flags;
+	uint64_t mi_data[(MCINFO_MAXSIZE - 1) / 8];
+};
+DEFINE_GUEST_HANDLE_STRUCT(mc_info);
+
+#define __MC_MSR_ARRAYSIZE 8
+#define __MC_MSR_MCGCAP 0
+#define __MC_NMSRS 1
+#define MC_NCAPS 7
+struct mcinfo_logical_cpu {
+	uint32_t mc_cpunr;
+	uint32_t mc_chipid;
+	uint16_t mc_coreid;
+	uint16_t mc_threadid;
+	uint32_t mc_apicid;
+	uint32_t mc_clusterid;
+	uint32_t mc_ncores;
+	uint32_t mc_ncores_active;
+	uint32_t mc_nthreads;
+	uint32_t mc_cpuid_level;
+	uint32_t mc_family;
+	uint32_t mc_vendor;
+	uint32_t mc_model;
+	uint32_t mc_step;
+	char mc_vendorid[16];
+	char mc_brandid[64];
+	uint32_t mc_cpu_caps[MC_NCAPS];
+	uint32_t mc_cache_size;
+	uint32_t mc_cache_alignment;
+	uint32_t mc_nmsrvals;
+	struct mcinfo_msr mc_msrvalues[__MC_MSR_ARRAYSIZE];
+};
+DEFINE_GUEST_HANDLE_STRUCT(mcinfo_logical_cpu);
+
+/*
+ * Prototype:
+ *    uint32_t x86_mcinfo_nentries(struct mc_info *mi);
+ */
+#define x86_mcinfo_nentries(_mi)    \
+	((_mi)->mi_nentries)
+/*
+ * Prototype:
+ *    struct mcinfo_common *x86_mcinfo_first(struct mc_info *mi);
+ */
+#define x86_mcinfo_first(_mi)       \
+	((struct mcinfo_common *)(_mi)->mi_data)
+/*
+ * Prototype:
+ *    struct mcinfo_common *x86_mcinfo_next(struct mcinfo_common *mic);
+ */
+#define x86_mcinfo_next(_mic)       \
+	((struct mcinfo_common *)((uint8_t *)(_mic) + (_mic)->size))
+
+/*
+ * Prototype:
+ *    void x86_mcinfo_lookup(void *ret, struct mc_info *mi, uint16_t type)=
;
+ */
+static inline void x86_mcinfo_lookup(struct mcinfo_common **ret,
+				     struct mc_info *mi, uint16_t type)
+{
+	uint32_t i;
+	struct mcinfo_common *mic;
+	bool found =3D 0;
+
+	if (!ret || !mi)
+		return;
+
+	mic =3D x86_mcinfo_first(mi);
+	for (i =3D 0; i < x86_mcinfo_nentries(mi); i++) {
+		if (mic->type =3D=3D type) {
+			found =3D 1;
+			break;
+		}
+		mic =3D x86_mcinfo_next(mic);
+	}
+
+	*ret =3D found ? mic : NULL;
+}
+
+/*
+ * Fetch machine check data from hypervisor.
+ */
+#define XEN_MC_fetch		1
+struct xen_mc_fetch {
+	/*
+	 * IN: XEN_MC_NONURGENT, XEN_MC_URGENT,
+	 * XEN_MC_ACK if ack'king an earlier fetch
+	 * OUT: XEN_MC_OK, XEN_MC_FETCHAILED, XEN_MC_NODATA
+	 */
+	uint32_t flags;
+	uint32_t _pad0;
+	/* OUT: id for ack, IN: id we are ack'ing */
+	uint64_t fetch_id;
+
+	/* OUT variables. */
+	GUEST_HANDLE(mc_info) data;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_mc_fetch);
+
+
+/*
+ * This tells the hypervisor to notify a DomU about the machine check erro=
r
+ */
+#define XEN_MC_notifydomain	2
+struct xen_mc_notifydomain {
+	/* IN variables */
+	uint16_t mc_domid; /* The unprivileged domain to notify */
+	uint16_t mc_vcpuid; /* The vcpu in mc_domid to notify */
+
+	/* IN/OUT variables */
+	uint32_t flags;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_mc_notifydomain);
+
+#define XEN_MC_physcpuinfo	3
+struct xen_mc_physcpuinfo {
+	/* IN/OUT */
+	uint32_t ncpus;
+	uint32_t _pad0;
+	/* OUT */
+	GUEST_HANDLE(mcinfo_logical_cpu) info;
+};
+
+#define XEN_MC_msrinject	4
+#define MC_MSRINJ_MAXMSRS	8
+struct xen_mc_msrinject {
+	/* IN */
+	uint32_t mcinj_cpunr; /* target processor id */
+	uint32_t mcinj_flags; /* see MC_MSRINJ_F_* below */
+	uint32_t mcinj_count; /* 0 .. count-1 in array are valid */
+	uint32_t _pad0;
+	struct mcinfo_msr mcinj_msr[MC_MSRINJ_MAXMSRS];
+};
+
+/* Flags for mcinj_flags above; bits 16-31 are reserved */
+#define MC_MSRINJ_F_INTERPOSE	0x1
+
+#define XEN_MC_mceinject	5
+struct xen_mc_mceinject {
+	unsigned int mceinj_cpunr; /* target processor id */
+};
+
+struct xen_mc {
+	uint32_t cmd;
+	uint32_t interface_version; /* XEN_MCA_INTERFACE_VERSION */
+	union {
+		struct xen_mc_fetch        mc_fetch;
+		struct xen_mc_notifydomain mc_notifydomain;
+		struct xen_mc_physcpuinfo  mc_physcpuinfo;
+		struct xen_mc_msrinject    mc_msrinject;
+		struct xen_mc_mceinject    mc_mceinject;
+	} u;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_mc);
+
+#endif /* __ASSEMBLY__ */
+#endif /* __XEN_PUBLIC_ARCH_X86_MCA_H__ */
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC8292335146A62SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-Add-mcelog-support-for-xen-platform.patch"
Content-Description: 0001-Add-mcelog-support-for-xen-platform.patch
Content-Disposition: attachment;
	filename="0001-Add-mcelog-support-for-xen-platform.patch"; size=19856;
	creation-date="Mon, 16 Apr 2012 00:42:43 GMT";
	modification-date="Mon, 16 Apr 2012 08:25:54 GMT"
Content-Transfer-Encoding: base64

RnJvbSAwZWUwNjUxNzU2ZWI2MjU1YmM4MWRhOGE3YjYzMTNiYWI0YjgwZDFlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogU3VuLCAxNSBBcHIgMjAxMiAyMjo1ODozNCArMDgwMApTdWJqZWN0OiBbUEFUQ0ggMS8y
XSBBZGQgbWNlbG9nIHN1cHBvcnQgZm9yIHhlbiBwbGF0Zm9ybQoKV2hlbiBNQ0EgZXJyb3Igb2Nj
dXJzLCBpdCB3b3VsZCBiZSBoYW5kbGVkIGJ5IHhlbiBoeXBlcnZpc29yIGZpcnN0LAphbmQgdGhl
biB0aGUgZXJyb3IgaW5mb3JtYXRpb24gd291bGQgYmUgc2VudCB0byBkb20wIGZvciBsb2dnaW5n
LgoKVGhpcyBwYXRjaCBnZXRzIGVycm9yIGluZm9ybWF0aW9uIGZyb20geGVuIGh5cGVydmlzb3Ig
YW5kIGNvbnZlcnQKeGVuIGZvcm1hdCBlcnJvciBpbnRvIGxpbnV4IGZvcm1hdCBtY2Vsb2cuIFRo
aXMgbG9naWMgaXMgYmFzaWNhbGx5CnNlbGYtY29udGFpbmVkLCBub3QgbXVjaCB0b3VjaGluZyBv
dGhlciBrZXJuZWwgY29tcG9uZW50cy4KClNvIHVuZGVyIHhlbiBwbGF0Zm9ybSB3aGVuIE1DQSBl
cnJvciBvY2N1cnMsIHRoZSBlcnJvciBpbmZvcm1hdGlvbgp3b3VsZCBiZSBzZW50IHRvIGRvbTAg
YW5kIGNvbnZlcnRlZCBpbnRvIG5hdGl2ZSBsaW51eCBtY2Vsb2cgZm9ybWF0LgpCeSB1c2luZyB0
b29scyBsaWtlIG1jZWxvZyB0b29sIHVzZXJzIGNvdWxkIHJlYWQgc3BlY2lmaWMgZXJyb3IgaW5m
b3JtYXRpb24sCmxpa2Ugd2hhdCB0aGV5IGRpZCB1bmRlciBuYXRpdmUgbGludXguCgpTaWduZWQt
b2ZmLWJ5OiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4KU2lnbmVkLW9mZi1i
eTogS2UsIExpcGluZyA8bGlwaW5nLmtlQGludGVsLmNvbT4KU2lnbmVkLW9mZi1ieTogSmlhbmcs
IFl1bmhvbmcgPHl1bmhvbmcuamlhbmdAaW50ZWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBKZXJlbXkg
Rml0emhhcmRpbmdlIDxqZXJlbXkuZml0emhhcmRpbmdlQGNpdHJpeC5jb20+Ci0tLQogYXJjaC94
ODYvaW5jbHVkZS9hc20veGVuL2h5cGVyY2FsbC5oIHwgICAgOCArCiBhcmNoL3g4Ni94ZW4vZW5s
aWdodGVuLmMgICAgICAgICAgICAgfCAgICA0ICstCiBkcml2ZXJzL3hlbi9LY29uZmlnICAgICAg
ICAgICAgICAgICAgfCAgICA4ICsKIGRyaXZlcnMveGVuL01ha2VmaWxlICAgICAgICAgICAgICAg
ICB8ICAgIDEgKwogZHJpdmVycy94ZW4vbWNlbG9nLmMgICAgICAgICAgICAgICAgIHwgIDIwMSAr
KysrKysrKysrKysrKysrKysrKwogaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3hlbi1tY2EuaCAgICAg
IHwgIDMzNiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCiA2IGZpbGVzIGNoYW5n
ZWQsIDU1NSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQogY3JlYXRlIG1vZGUgMTAwNjQ0
IGRyaXZlcnMveGVuL21jZWxvZy5jCiBjcmVhdGUgbW9kZSAxMDA2NDQgaW5jbHVkZS94ZW4vaW50
ZXJmYWNlL3hlbi1tY2EuaAoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3hlbi9o
eXBlcmNhbGwuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3hlbi9oeXBlcmNhbGwuaAppbmRleCA1
NzI4ODUyLi41OWMyMjZkIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS94ZW4vaHlw
ZXJjYWxsLmgKKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20veGVuL2h5cGVyY2FsbC5oCkBAIC00
OCw2ICs0OCw3IEBACiAjaW5jbHVkZSA8eGVuL2ludGVyZmFjZS9zY2hlZC5oPgogI2luY2x1ZGUg
PHhlbi9pbnRlcmZhY2UvcGh5c2Rldi5oPgogI2luY2x1ZGUgPHhlbi9pbnRlcmZhY2UvcGxhdGZv
cm0uaD4KKyNpbmNsdWRlIDx4ZW4vaW50ZXJmYWNlL3hlbi1tY2EuaD4KIAogLyoKICAqIFRoZSBo
eXBlcmNhbGwgYXNtcyBoYXZlIHRvIG1lZXQgc2V2ZXJhbCBjb25zdHJhaW50czoKQEAgLTMwMiw2
ICszMDMsMTMgQEAgSFlQRVJWSVNPUl9zZXRfdGltZXJfb3AodTY0IHRpbWVvdXQpCiB9CiAKIHN0
YXRpYyBpbmxpbmUgaW50CitIWVBFUlZJU09SX21jYShzdHJ1Y3QgeGVuX21jICptY19vcCkKK3sK
KwltY19vcC0+aW50ZXJmYWNlX3ZlcnNpb24gPSBYRU5fTUNBX0lOVEVSRkFDRV9WRVJTSU9OOwor
CXJldHVybiBfaHlwZXJjYWxsMShpbnQsIG1jYSwgbWNfb3ApOworfQorCitzdGF0aWMgaW5saW5l
IGludAogSFlQRVJWSVNPUl9kb20wX29wKHN0cnVjdCB4ZW5fcGxhdGZvcm1fb3AgKnBsYXRmb3Jt
X29wKQogewogCXBsYXRmb3JtX29wLT5pbnRlcmZhY2VfdmVyc2lvbiA9IFhFTlBGX0lOVEVSRkFD
RV9WRVJTSU9OOwpkaWZmIC0tZ2l0IGEvYXJjaC94ODYveGVuL2VubGlnaHRlbi5jIGIvYXJjaC94
ODYveGVuL2VubGlnaHRlbi5jCmluZGV4IDRmNTFiZWIuLjE1NjI4ZDQgMTAwNjQ0Ci0tLSBhL2Fy
Y2gveDg2L3hlbi9lbmxpZ2h0ZW4uYworKysgYi9hcmNoL3g4Ni94ZW4vZW5saWdodGVuLmMKQEAg
LTMyOSw5ICszMjksNyBAQCBzdGF0aWMgdm9pZCBfX2luaXQgeGVuX2luaXRfY3B1aWRfbWFzayh2
b2lkKQogCXVuc2lnbmVkIGludCB4c2F2ZV9tYXNrOwogCiAJY3B1aWRfbGVhZjFfZWR4X21hc2sg
PQotCQl+KCgxIDw8IFg4Nl9GRUFUVVJFX01DRSkgIHwgIC8qIGRpc2FibGUgTUNFICovCi0JCSAg
KDEgPDwgWDg2X0ZFQVRVUkVfTUNBKSAgfCAgLyogZGlzYWJsZSBNQ0EgKi8KLQkJICAoMSA8PCBY
ODZfRkVBVFVSRV9NVFJSKSB8ICAvKiBkaXNhYmxlIE1UUlIgKi8KKwkJfigoMSA8PCBYODZfRkVB
VFVSRV9NVFJSKSB8ICAvKiBkaXNhYmxlIE1UUlIgKi8KIAkJICAoMSA8PCBYODZfRkVBVFVSRV9B
Q0MpKTsgICAvKiB0aGVybWFsIG1vbml0b3JpbmcgKi8KIAogCWlmICgheGVuX2luaXRpYWxfZG9t
YWluKCkpCmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi9LY29uZmlnIGIvZHJpdmVycy94ZW4vS2Nv
bmZpZwppbmRleCA5NDI0MzEzLi5mNDVmOTIzIDEwMDY0NAotLS0gYS9kcml2ZXJzL3hlbi9LY29u
ZmlnCisrKyBiL2RyaXZlcnMveGVuL0tjb25maWcKQEAgLTE5NCw0ICsxOTQsMTIgQEAgY29uZmln
IFhFTl9BQ1BJX1BST0NFU1NPUgogICAgICAgICAgIG1vZHVsZSB3aWxsIGJlIGNhbGxlZCB4ZW5f
YWNwaV9wcm9jZXNzb3IgIElmIHlvdSBkbyBub3Qga25vdyB3aGF0IHRvIGNob29zZSwKICAgICAg
ICAgICBzZWxlY3QgTSBoZXJlLiBJZiB0aGUgQ1BVRlJFUSBkcml2ZXJzIGFyZSBidWlsdCBpbiwg
c2VsZWN0IFkgaGVyZS4KIAorY29uZmlnIFhFTl9NQ0VfTE9HCisJYm9vbCAiWGVuIHBsYXRmb3Jt
IG1jZWxvZyIKKwlkZXBlbmRzIG9uIFhFTl9ET00wICYmIFg4Nl82NCAmJiBYODZfTUNFCisJZGVm
YXVsdCBuCisJaGVscAorCSAgQWxsb3cga2VybmVsIGZldGNoaW5nIG1jZSBsb2cgZnJvbSB4ZW4g
cGxhdGZvcm0gYW5kCisJICBjb252ZXJ0aW5nIGl0IGludG8gbGludXggbWNlbG9nIGZvcm1hdCBm
b3IgbWNlbG9nIHRvb2xzCisKIGVuZG1lbnUKZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVuL01ha2Vm
aWxlIGIvZHJpdmVycy94ZW4vTWFrZWZpbGUKaW5kZXggOWFkYzViZS4uMWQzZTc2MyAxMDA2NDQK
LS0tIGEvZHJpdmVycy94ZW4vTWFrZWZpbGUKKysrIGIvZHJpdmVycy94ZW4vTWFrZWZpbGUKQEAg
LTE0LDYgKzE0LDcgQEAgb2JqLSQoQ09ORklHX1hFTl9HTlRERVYpCQkrPSB4ZW4tZ250ZGV2Lm8K
IG9iai0kKENPTkZJR19YRU5fR1JBTlRfREVWX0FMTE9DKQkrPSB4ZW4tZ250YWxsb2Mubwogb2Jq
LSQoQ09ORklHX1hFTkZTKQkJCSs9IHhlbmZzLwogb2JqLSQoQ09ORklHX1hFTl9TWVNfSFlQRVJW
SVNPUikJKz0gc3lzLWh5cGVydmlzb3Iubworb2JqLSQoQ09ORklHX1hFTl9NQ0VfTE9HKQkJKz0g
bWNlbG9nLm8KIG9iai0kKENPTkZJR19YRU5fUFZIVk0pCQkJKz0gcGxhdGZvcm0tcGNpLm8KIG9i
ai0kKENPTkZJR19YRU5fVE1FTSkJCQkrPSB0bWVtLm8KIG9iai0kKENPTkZJR19TV0lPVExCX1hF
TikJCSs9IHN3aW90bGIteGVuLm8KZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVuL21jZWxvZy5jIGIv
ZHJpdmVycy94ZW4vbWNlbG9nLmMKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4u
ZTlmODZiOAotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZlcnMveGVuL21jZWxvZy5jCkBAIC0wLDAg
KzEsMjAxIEBACisvKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCisgKiBtY2Vsb2cuYworICogRHJpdmVy
IGZvciByZWNlaXZpbmcgYW5kIHRyYW5zZmVycmluZyBtYWNoaW5lIGNoZWNrIGVycm9yIGluZm9t
YXRpb24KKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTIgSW50ZWwgQ29ycG9yYXRpb24KKyAqIEF1
dGhvcjogTGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+CisgKiBBdXRob3I6IEpp
YW5nLCBZdW5ob25nIDx5dW5ob25nLmppYW5nQGludGVsLmNvbT4KKyAqIEF1dGhvcjogS2UsIExp
cGluZyA8bGlwaW5nLmtlQGludGVsLmNvbT4KKyAqCisgKiBUaGlzIHByb2dyYW0gaXMgZnJlZSBz
b2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yCisgKiBtb2RpZnkgaXQgdW5k
ZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSB2ZXJzaW9uIDIK
KyAqIGFzIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBvciwgd2hl
biBkaXN0cmlidXRlZAorICogc2VwYXJhdGVseSBmcm9tIHRoZSBMaW51eCBrZXJuZWwgb3IgaW5j
b3Jwb3JhdGVkIGludG8gb3RoZXIKKyAqIHNvZnR3YXJlIHBhY2thZ2VzLCBzdWJqZWN0IHRvIHRo
ZSBmb2xsb3dpbmcgbGljZW5zZToKKyAqCisgKiBQZXJtaXNzaW9uIGlzIGhlcmVieSBncmFudGVk
LCBmcmVlIG9mIGNoYXJnZSwgdG8gYW55IHBlcnNvbiBvYnRhaW5pbmcgYSBjb3B5CisgKiBvZiB0
aGlzIHNvdXJjZSBmaWxlICh0aGUgIlNvZnR3YXJlIiksIHRvIGRlYWwgaW4gdGhlIFNvZnR3YXJl
IHdpdGhvdXQKKyAqIHJlc3RyaWN0aW9uLCBpbmNsdWRpbmcgd2l0aG91dCBsaW1pdGF0aW9uIHRo
ZSByaWdodHMgdG8gdXNlLCBjb3B5LCBtb2RpZnksCisgKiBtZXJnZSwgcHVibGlzaCwgZGlzdHJp
YnV0ZSwgc3VibGljZW5zZSwgYW5kL29yIHNlbGwgY29waWVzIG9mIHRoZSBTb2Z0d2FyZSwKKyAq
IGFuZCB0byBwZXJtaXQgcGVyc29ucyB0byB3aG9tIHRoZSBTb2Z0d2FyZSBpcyBmdXJuaXNoZWQg
dG8gZG8gc28sIHN1YmplY3QgdG8KKyAqIHRoZSBmb2xsb3dpbmcgY29uZGl0aW9uczoKKyAqCisg
KiBUaGUgYWJvdmUgY29weXJpZ2h0IG5vdGljZSBhbmQgdGhpcyBwZXJtaXNzaW9uIG5vdGljZSBz
aGFsbCBiZSBpbmNsdWRlZCBpbgorICogYWxsIGNvcGllcyBvciBzdWJzdGFudGlhbCBwb3J0aW9u
cyBvZiB0aGUgU29mdHdhcmUuCisgKgorICogVEhFIFNPRlRXQVJFIElTIFBST1ZJREVEICJBUyBJ
UyIsIFdJVEhPVVQgV0FSUkFOVFkgT0YgQU5ZIEtJTkQsIEVYUFJFU1MgT1IKKyAqIElNUExJRUQs
IElOQ0xVRElORyBCVVQgTk9UIExJTUlURUQgVE8gVEhFIFdBUlJBTlRJRVMgT0YgTUVSQ0hBTlRB
QklMSVRZLAorICogRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UgQU5EIE5PTklORlJJ
TkdFTUVOVC4gSU4gTk8gRVZFTlQgU0hBTEwgVEhFCisgKiBBVVRIT1JTIE9SIENPUFlSSUdIVCBI
T0xERVJTIEJFIExJQUJMRSBGT1IgQU5ZIENMQUlNLCBEQU1BR0VTIE9SIE9USEVSCisgKiBMSUFC
SUxJVFksIFdIRVRIRVIgSU4gQU4gQUNUSU9OIE9GIENPTlRSQUNULCBUT1JUIE9SIE9USEVSV0lT
RSwgQVJJU0lORworICogRlJPTSwgT1VUIE9GIE9SIElOIENPTk5FQ1RJT04gV0lUSCBUSEUgU09G
VFdBUkUgT1IgVEhFIFVTRSBPUiBPVEhFUiBERUFMSU5HUworICogSU4gVEhFIFNPRlRXQVJFLgor
ICovCisKKyNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KKyNpbmNsdWRlIDxsaW51eC9pbml0Lmg+
CisjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4KKyNpbmNsdWRlIDxsaW51eC9rZXJuZWwuaD4KKyNp
bmNsdWRlIDxsaW51eC9zbGFiLmg+CisjaW5jbHVkZSA8eGVuL2ludGVyZmFjZS94ZW4uaD4KKyNp
bmNsdWRlIDxhc20veGVuL2h5cGVydmlzb3IuaD4KKyNpbmNsdWRlIDx4ZW4vZXZlbnRzLmg+Cisj
aW5jbHVkZSA8eGVuL2ludGVyZmFjZS92Y3B1Lmg+CisjaW5jbHVkZSA8YXNtL3hlbi9oeXBlcmNh
bGwuaD4KKyNpbmNsdWRlIDxhc20vbWNlLmg+CisjaW5jbHVkZSA8eGVuL3hlbi5oPgorCitzdGF0
aWMgc3RydWN0IG1jX2luZm8gZ19taTsKK3N0YXRpYyBzdHJ1Y3QgbWNpbmZvX2xvZ2ljYWxfY3B1
ICpnX3BoeXNpbmZvOworc3RhdGljIHVpbnQzMl90IG5jcHVzOworCitzdGF0aWMgREVGSU5FX1NQ
SU5MT0NLKG1jZWxvZ19sb2NrKTsKKworc3RhdGljIHZvaWQgY29udmVydF9sb2coc3RydWN0IG1j
X2luZm8gKm1pKQoreworCXN0cnVjdCBtY2luZm9fY29tbW9uICptaWM7CisJc3RydWN0IG1jaW5m
b19nbG9iYWwgKm1jX2dsb2JhbDsKKwlzdHJ1Y3QgbWNpbmZvX2JhbmsgKm1jX2Jhbms7CisJc3Ry
dWN0IG1jZSBtOworCWludCBpOworCisJbWljID0gTlVMTDsKKwl4ODZfbWNpbmZvX2xvb2t1cCgm
bWljLCBtaSwgTUNfVFlQRV9HTE9CQUwpOworCWlmICh1bmxpa2VseSghbWljKSkKKwkJcmV0dXJu
OworCisJbWNlX3NldHVwKCZtKTsKKwltY19nbG9iYWwgPSAoc3RydWN0IG1jaW5mb19nbG9iYWwg
KiltaWM7CisJbS5tY2dzdGF0dXMgPSBtY19nbG9iYWwtPm1jX2dzdGF0dXM7CisJbS5hcGljaWQg
PSBtY19nbG9iYWwtPm1jX2FwaWNpZDsKKworCWZvciAoaSA9IDA7IGkgPCBuY3B1czsgaSsrKQor
CQlpZiAoZ19waHlzaW5mb1tpXS5tY19hcGljaWQgPT0gbS5hcGljaWQpCisJCQlicmVhazsKKwlp
ZiAodW5saWtlbHkoaSA9PSBuY3B1cykpCisJCXJldHVybjsKKworCW0uc29ja2V0aWQgPSBnX3Bo
eXNpbmZvW2ldLm1jX2NoaXBpZDsKKwltLmNwdSA9IG0uZXh0Y3B1ID0gZ19waHlzaW5mb1tpXS5t
Y19jcHVucjsKKwltLmNwdXZlbmRvciA9IChfX3U4KWdfcGh5c2luZm9baV0ubWNfdmVuZG9yOwor
CW0ubWNnY2FwID0gZ19waHlzaW5mb1tpXS5tY19tc3J2YWx1ZXNbX19NQ19NU1JfTUNHQ0FQXS52
YWx1ZTsKKworCW1pYyA9IE5VTEw7CisJeDg2X21jaW5mb19sb29rdXAoJm1pYywgbWksIE1DX1RZ
UEVfQkFOSyk7CisKKwlkbyB7CisJCWlmICgoIW1pYykgfHwgKG1pYy0+c2l6ZSA9PSAwKSB8fAor
CQkgICAgKG1pYy0+dHlwZSAhPSBNQ19UWVBFX0dMT0JBTCAgICYmCisJCSAgICAgbWljLT50eXBl
ICE9IE1DX1RZUEVfQkFOSyAgICAgJiYKKwkJICAgICBtaWMtPnR5cGUgIT0gTUNfVFlQRV9FWFRF
TkRFRCAmJgorCQkgICAgIG1pYy0+dHlwZSAhPSBNQ19UWVBFX1JFQ09WRVJZKSkKKwkJCWJyZWFr
OworCisJCWlmIChtaWMtPnR5cGUgPT0gTUNfVFlQRV9CQU5LKSB7CisJCQltY19iYW5rID0gKHN0
cnVjdCBtY2luZm9fYmFuayAqKW1pYzsKKwkJCW0ubWlzYyA9IG1jX2JhbmstPm1jX21pc2M7CisJ
CQltLnN0YXR1cyA9IG1jX2JhbmstPm1jX3N0YXR1czsKKwkJCW0uYWRkciA9IG1jX2JhbmstPm1j
X2FkZHI7CisJCQltLnRzYyA9IG1jX2JhbmstPm1jX3RzYzsKKwkJCW0uYmFuayA9IG1jX2Jhbmst
Pm1jX2Jhbms7CisJCQltLmZpbmlzaGVkID0gMTsKKwkJCS8qbG9nIHRoaXMgcmVjb3JkKi8KKwkJ
CW1jZV9sb2coJm0pOworCQl9CisJCW1pYyA9IHg4Nl9tY2luZm9fbmV4dChtaWMpOworCX0gd2hp
bGUgKDEpOworfQorCitzdGF0aWMgdm9pZCBtY19xdWV1ZV9oYW5kbGUodWludDMyX3QgZmxhZ3Mp
Cit7CisJc3RydWN0IHhlbl9tYyBtY19vcDsKKwlpbnQgcmV0ID0gMDsKKwl1bnNpZ25lZCBsb25n
IHRtcDsKKworCXNwaW5fbG9ja19pcnFzYXZlKCZtY2Vsb2dfbG9jaywgdG1wKTsKKworCW1jX29w
LmNtZCA9IFhFTl9NQ19mZXRjaDsKKwltY19vcC5pbnRlcmZhY2VfdmVyc2lvbiA9IFhFTl9NQ0Ff
SU5URVJGQUNFX1ZFUlNJT047CisJc2V0X3hlbl9ndWVzdF9oYW5kbGUobWNfb3AudS5tY19mZXRj
aC5kYXRhLCAmZ19taSk7CisJZG8geworCQltY19vcC51Lm1jX2ZldGNoLmZsYWdzID0gZmxhZ3M7
CisJCXJldCA9IEhZUEVSVklTT1JfbWNhKCZtY19vcCk7CisJCWlmIChyZXQgfHwgbWNfb3AudS5t
Y19mZXRjaC5mbGFncyAmIFhFTl9NQ19OT0RBVEEgfHwKKwkJICAgIG1jX29wLnUubWNfZmV0Y2gu
ZmxhZ3MgJiBYRU5fTUNfRkVUQ0hGQUlMRUQpCisJCQlicmVhazsKKwkJZWxzZSB7CisJCQljb252
ZXJ0X2xvZygmZ19taSk7CisJCQltY19vcC51Lm1jX2ZldGNoLmZsYWdzID0gZmxhZ3MgfCBYRU5f
TUNfQUNLOworCQkJcmV0ID0gSFlQRVJWSVNPUl9tY2EoJm1jX29wKTsKKwkJCWlmIChyZXQpCisJ
CQkJYnJlYWs7CisJCX0KKwl9IHdoaWxlICgxKTsKKworCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUo
Jm1jZWxvZ19sb2NrLCB0bXApOworCisJcmV0dXJuOworfQorCisvKiB2aXJxIGhhbmRsZXIgZm9y
IG1hY2hpbmUgY2hlY2sgZXJyb3IgaW5mbyovCitzdGF0aWMgaXJxcmV0dXJuX3QgbWNlX2RvbV9p
bnRlcnJ1cHQoaW50IGlycSwgdm9pZCAqZGV2X2lkKQoreworCS8qIHVyZ2VudCBtY19pbmZvICov
CisJbWNfcXVldWVfaGFuZGxlKFhFTl9NQ19VUkdFTlQpOworCisJLyogbm9udXJnZW50IG1jX2lu
Zm8gKi8KKwltY19xdWV1ZV9oYW5kbGUoWEVOX01DX05PTlVSR0VOVCk7CisKKwlyZXR1cm4gSVJR
X0hBTkRMRUQ7Cit9CisKK3N0YXRpYyBpbnQgYmluZF92aXJxX2Zvcl9tY2Uodm9pZCkKK3sKKwlp
bnQgcmV0OworCXN0cnVjdCB4ZW5fbWMgbWNfb3A7CisKKwltZW1zZXQoJm1jX29wLCAwLCBzaXpl
b2Yoc3RydWN0IHhlbl9tYykpOworCisJLyogRmV0Y2ggcGh5c2ljYWwgQ1BVIE51bWJlcnMgKi8K
KwltY19vcC5jbWQgPSBYRU5fTUNfcGh5c2NwdWluZm87CisJbWNfb3AuaW50ZXJmYWNlX3ZlcnNp
b24gPSBYRU5fTUNBX0lOVEVSRkFDRV9WRVJTSU9OOworCXNldF94ZW5fZ3Vlc3RfaGFuZGxlKG1j
X29wLnUubWNfcGh5c2NwdWluZm8uaW5mbywgZ19waHlzaW5mbyk7CisJcmV0ID0gSFlQRVJWSVNP
Ul9tY2EoJm1jX29wKTsKKwlpZiAocmV0KSB7CisJCXByaW50ayhLRVJOX0VSUiAiTUNFX0xPRzog
RmFpbGVkIHRvIGdldCBDUFUgbnVtYmVyc1xuIik7CisJCXJldHVybiByZXQ7CisJfQorCisJLyog
RmV0Y2ggZWFjaCBDUFUgUGh5c2ljYWwgSW5mbyBmb3IgbGF0ZXIgcmVmZXJlbmNlKi8KKwluY3B1
cyA9IG1jX29wLnUubWNfcGh5c2NwdWluZm8ubmNwdXM7CisJZ19waHlzaW5mbyA9IGt6YWxsb2Mo
c2l6ZW9mKHN0cnVjdCBtY2luZm9fbG9naWNhbF9jcHUpICogbmNwdXMsCisJCQkgICAgIEdGUF9L
RVJORUwpOworCWlmICghZ19waHlzaW5mbykKKwkJcmV0dXJuIC1FTk9NRU07CisJc2V0X3hlbl9n
dWVzdF9oYW5kbGUobWNfb3AudS5tY19waHlzY3B1aW5mby5pbmZvLCBnX3BoeXNpbmZvKTsKKwly
ZXQgPSBIWVBFUlZJU09SX21jYSgmbWNfb3ApOworCWlmIChyZXQpIHsKKwkJcHJpbnRrKEtFUk5f
RVJSICJNQ0VfTE9HOiBGYWlsZWQgdG8gZ2V0IENQVSBpbmZvXG4iKTsKKwkJa2ZyZWUoZ19waHlz
aW5mbyk7CisJCXJldHVybiByZXQ7CisJfQorCisJcmV0ICA9IGJpbmRfdmlycV90b19pcnFoYW5k
bGVyKFZJUlFfTUNBLCAwLAorCQkJCSAgICAgICBtY2VfZG9tX2ludGVycnVwdCwgMCwgIm1jZSIs
IE5VTEwpOworCWlmIChyZXQgPCAwKSB7CisJCXByaW50ayhLRVJOX0VSUiAiTUNFX0xPRzogRmFp
bGVkIHRvIGJpbmQgdmlycVxuIik7CisJCWtmcmVlKGdfcGh5c2luZm8pOworCX0KKworCXJldHVy
biByZXQ7Cit9CisKK3N0YXRpYyBpbnQgX19pbml0IG1jZWxvZ19pbml0KHZvaWQpCit7CisJLyog
T25seSBET00wIGlzIHJlc3BvbnNpYmxlIGZvciBNQ0UgbG9nZ2luZyAqLworCWlmICh4ZW5faW5p
dGlhbF9kb21haW4oKSkKKwkJcmV0dXJuIGJpbmRfdmlycV9mb3JfbWNlKCk7CisKKwlyZXR1cm4g
LUVOT0RFVjsKK30KK2xhdGVfaW5pdGNhbGwobWNlbG9nX2luaXQpOwpkaWZmIC0tZ2l0IGEvaW5j
bHVkZS94ZW4vaW50ZXJmYWNlL3hlbi1tY2EuaCBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS94ZW4t
bWNhLmgKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uZjI1NjFkYgotLS0gL2Rl
di9udWxsCisrKyBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS94ZW4tbWNhLmgKQEAgLTAsMCArMSwz
MzYgQEAKKy8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioKKyAqIGFyY2gteDg2L21jYS5oCisgKiBHdWVz
dCBPUyBtYWNoaW5lIGNoZWNrIGludGVyZmFjZSB0byB4ODYgWGVuLgorICoKKyAqIENvbnRyaWJ1
dGVkIGJ5IEFkdmFuY2VkIE1pY3JvIERldmljZXMsIEluYy4KKyAqIEF1dGhvcjogQ2hyaXN0b3Bo
IEVnZ2VyIDxDaHJpc3RvcGguRWdnZXJAYW1kLmNvbT4KKyAqCisgKiBVcGRhdGVkIGJ5IEludGVs
IENvcnBvcmF0aW9uCisgKiBBdXRob3I6IExpdSwgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwu
Y29tPgorICoKKyAqIFBlcm1pc3Npb24gaXMgaGVyZWJ5IGdyYW50ZWQsIGZyZWUgb2YgY2hhcmdl
LCB0byBhbnkgcGVyc29uIG9idGFpbmluZyBhIGNvcHkKKyAqIG9mIHRoaXMgc29mdHdhcmUgYW5k
IGFzc29jaWF0ZWQgZG9jdW1lbnRhdGlvbiBmaWxlcyAodGhlICJTb2Z0d2FyZSIpLCB0bworICog
ZGVhbCBpbiB0aGUgU29mdHdhcmUgd2l0aG91dCByZXN0cmljdGlvbiwgaW5jbHVkaW5nIHdpdGhv
dXQgbGltaXRhdGlvbiB0aGUKKyAqIHJpZ2h0cyB0byB1c2UsIGNvcHksIG1vZGlmeSwgbWVyZ2Us
IHB1Ymxpc2gsIGRpc3RyaWJ1dGUsIHN1YmxpY2Vuc2UsIGFuZC9vcgorICogc2VsbCBjb3BpZXMg
b2YgdGhlIFNvZnR3YXJlLCBhbmQgdG8gcGVybWl0IHBlcnNvbnMgdG8gd2hvbSB0aGUgU29mdHdh
cmUgaXMKKyAqIGZ1cm5pc2hlZCB0byBkbyBzbywgc3ViamVjdCB0byB0aGUgZm9sbG93aW5nIGNv
bmRpdGlvbnM6CisgKgorICogVGhlIGFib3ZlIGNvcHlyaWdodCBub3RpY2UgYW5kIHRoaXMgcGVy
bWlzc2lvbiBub3RpY2Ugc2hhbGwgYmUgaW5jbHVkZWQgaW4KKyAqIGFsbCBjb3BpZXMgb3Igc3Vi
c3RhbnRpYWwgcG9ydGlvbnMgb2YgdGhlIFNvZnR3YXJlLgorICoKKyAqIFRIRSBTT0ZUV0FSRSBJ
UyBQUk9WSURFRCAiQVMgSVMiLCBXSVRIT1VUIFdBUlJBTlRZIE9GIEFOWSBLSU5ELCBFWFBSRVNT
IE9SCisgKiBJTVBMSUVELCBJTkNMVURJTkcgQlVUIE5PVCBMSU1JVEVEIFRPIFRIRSBXQVJSQU5U
SUVTIE9GIE1FUkNIQU5UQUJJTElUWSwKKyAqIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQ
T1NFIEFORCBOT05JTkZSSU5HRU1FTlQuIElOIE5PIEVWRU5UIFNIQUxMIFRIRQorICogQVVUSE9S
UyBPUiBDT1BZUklHSFQgSE9MREVSUyBCRSBMSUFCTEUgRk9SIEFOWSBDTEFJTSwgREFNQUdFUyBP
UiBPVEhFUgorICogTElBQklMSVRZLCBXSEVUSEVSIElOIEFOIEFDVElPTiBPRiBDT05UUkFDVCwg
VE9SVCBPUiBPVEhFUldJU0UsIEFSSVNJTkcKKyAqIEZST00sIE9VVCBPRiBPUiBJTiBDT05ORUNU
SU9OIFdJVEggVEhFIFNPRlRXQVJFIE9SIFRIRSBVU0UgT1IgT1RIRVIKKyAqIERFQUxJTkdTIElO
IFRIRSBTT0ZUV0FSRS4KKyAqLworCisjaWZuZGVmIF9fWEVOX1BVQkxJQ19BUkNIX1g4Nl9NQ0Ff
SF9fCisjZGVmaW5lIF9fWEVOX1BVQkxJQ19BUkNIX1g4Nl9NQ0FfSF9fCisKKy8qIEh5cGVyY2Fs
bCAqLworI2RlZmluZSBfX0hZUEVSVklTT1JfbWNhIF9fSFlQRVJWSVNPUl9hcmNoXzAKKworI2Rl
ZmluZSBYRU5fTUNBX0lOVEVSRkFDRV9WRVJTSU9OCTB4MDFlY2MwMDMKKworLyogSU46IERvbTAg
Y2FsbHMgaHlwZXJjYWxsIHRvIHJldHJpZXZlIG5vbnVyZ2VudCBlcnJvciBsb2cgZW50cnkgKi8K
KyNkZWZpbmUgWEVOX01DX05PTlVSR0VOVAkweDEKKy8qIElOOiBEb20wIGNhbGxzIGh5cGVyY2Fs
bCB0byByZXRyaWV2ZSB1cmdlbnQgZXJyb3IgbG9nIGVudHJ5ICovCisjZGVmaW5lIFhFTl9NQ19V
UkdFTlQJCTB4MgorLyogSU46IERvbTAgYWNrbm93bGVkZ2VzIHByZXZpb3NseS1mZXRjaGVkIGVy
cm9yIGxvZyBlbnRyeSAqLworI2RlZmluZSBYRU5fTUNfQUNLCQkweDQKKworLyogT1VUOiBBbGwg
aXMgb2sgKi8KKyNkZWZpbmUgWEVOX01DX09LCQkweDAKKy8qIE9VVDogRG9tYWluIGNvdWxkIG5v
dCBmZXRjaCBkYXRhLiAqLworI2RlZmluZSBYRU5fTUNfRkVUQ0hGQUlMRUQJMHgxCisvKiBPVVQ6
IFRoZXJlIHdhcyBubyBtYWNoaW5lIGNoZWNrIGRhdGEgdG8gZmV0Y2guICovCisjZGVmaW5lIFhF
Tl9NQ19OT0RBVEEJCTB4MgorCisjaWZuZGVmIF9fQVNTRU1CTFlfXworLyogdklSUSBpbmplY3Rl
ZCB0byBEb20wICovCisjZGVmaW5lIFZJUlFfTUNBIFZJUlFfQVJDSF8wCisKKy8qCisgKiBtY19p
bmZvIGVudHJ5IHR5cGVzCisgKiBtY2EgbWFjaGluZSBjaGVjayBpbmZvIGFyZSByZWNvcmRlZCBp
biBtY19pbmZvIGVudHJpZXMuCisgKiB3aGVuIGZldGNoIG1jYSBpbmZvLCBpdCBjYW4gdXNlIE1D
X1RZUEVfLi4uIHRvIGRpc3Rpbmd1aXNoCisgKiBkaWZmZXJlbnQgbWNhIGluZm8uCisgKi8KKyNk
ZWZpbmUgTUNfVFlQRV9HTE9CQUwJCTAKKyNkZWZpbmUgTUNfVFlQRV9CQU5LCQkxCisjZGVmaW5l
IE1DX1RZUEVfRVhURU5ERUQJMgorI2RlZmluZSBNQ19UWVBFX1JFQ09WRVJZCTMKKworc3RydWN0
IG1jaW5mb19jb21tb24geworCXVpbnQxNl90IHR5cGU7IC8qIHN0cnVjdHVyZSB0eXBlICovCisJ
dWludDE2X3Qgc2l6ZTsgLyogc2l6ZSBvZiB0aGlzIHN0cnVjdCBpbiBieXRlcyAqLworfTsKKwor
I2RlZmluZSBNQ19GTEFHX0NPUlJFQ1RBQkxFCSgxIDw8IDApCisjZGVmaW5lIE1DX0ZMQUdfVU5D
T1JSRUNUQUJMRQkoMSA8PCAxKQorI2RlZmluZSBNQ19GTEFHX1JFQ09WRVJBQkxFCSgxIDw8IDIp
CisjZGVmaW5lIE1DX0ZMQUdfUE9MTEVECQkoMSA8PCAzKQorI2RlZmluZSBNQ19GTEFHX1JFU0VU
CQkoMSA8PCA0KQorI2RlZmluZSBNQ19GTEFHX0NNQ0kJCSgxIDw8IDUpCisjZGVmaW5lIE1DX0ZM
QUdfTUNFCQkoMSA8PCA2KQorCisvKiBjb250YWlucyB4ODYgZ2xvYmFsIG1jIGluZm9ybWF0aW9u
ICovCitzdHJ1Y3QgbWNpbmZvX2dsb2JhbCB7CisJc3RydWN0IG1jaW5mb19jb21tb24gY29tbW9u
OworCisJdWludDE2X3QgbWNfZG9taWQ7IC8qIHJ1bm5pbmcgZG9tYWluIGF0IHRoZSB0aW1lIGlu
IGVycm9yICovCisJdWludDE2X3QgbWNfdmNwdWlkOyAvKiB2aXJ0dWFsIGNwdSBzY2hlZHVsZWQg
Zm9yIG1jX2RvbWlkICovCisJdWludDMyX3QgbWNfc29ja2V0aWQ7IC8qIHBoeXNpY2FsIHNvY2tl
dCBvZiB0aGUgcGh5c2ljYWwgY29yZSAqLworCXVpbnQxNl90IG1jX2NvcmVpZDsgLyogcGh5c2lj
YWwgaW1wYWN0ZWQgY29yZSAqLworCXVpbnQxNl90IG1jX2NvcmVfdGhyZWFkaWQ7IC8qIGNvcmUg
dGhyZWFkIG9mIHBoeXNpY2FsIGNvcmUgKi8KKwl1aW50MzJfdCBtY19hcGljaWQ7CisJdWludDMy
X3QgbWNfZmxhZ3M7CisJdWludDY0X3QgbWNfZ3N0YXR1czsgLyogZ2xvYmFsIHN0YXR1cyAqLwor
fTsKKworLyogY29udGFpbnMgeDg2IGJhbmsgbWMgaW5mb3JtYXRpb24gKi8KK3N0cnVjdCBtY2lu
Zm9fYmFuayB7CisJc3RydWN0IG1jaW5mb19jb21tb24gY29tbW9uOworCisJdWludDE2X3QgbWNf
YmFuazsgLyogYmFuayBuciAqLworCXVpbnQxNl90IG1jX2RvbWlkOyAvKiBkb21haW4gcmVmZXJl
bmNlZCBieSBtY19hZGRyIGlmIHZhbGlkICovCisJdWludDY0X3QgbWNfc3RhdHVzOyAvKiBiYW5r
IHN0YXR1cyAqLworCXVpbnQ2NF90IG1jX2FkZHI7IC8qIGJhbmsgYWRkcmVzcyAqLworCXVpbnQ2
NF90IG1jX21pc2M7CisJdWludDY0X3QgbWNfY3RybDI7CisJdWludDY0X3QgbWNfdHNjOworfTsK
Kworc3RydWN0IG1jaW5mb19tc3IgeworCXVpbnQ2NF90IHJlZzsgLyogTVNSICovCisJdWludDY0
X3QgdmFsdWU7IC8qIE1TUiB2YWx1ZSAqLworfTsKKworLyogY29udGFpbnMgbWMgaW5mb3JtYXRp
b24gZnJvbSBvdGhlciBvciBhZGRpdGlvbmFsIG1jIE1TUnMgKi8KK3N0cnVjdCBtY2luZm9fZXh0
ZW5kZWQgeworCXN0cnVjdCBtY2luZm9fY29tbW9uIGNvbW1vbjsKKwl1aW50MzJfdCBtY19tc3Jz
OyAvKiBOdW1iZXIgb2YgbXNyIHdpdGggdmFsaWQgdmFsdWVzLiAqLworCS8qCisJICogQ3VycmVu
dGx5IEludGVsIGV4dGVuZGVkIE1TUiAoMzIvNjQpIGluY2x1ZGUgYWxsIGdwIHJlZ2lzdGVycwor
CSAqIGFuZCBFKFIpRkxBR1MsIEUoUilJUCwgRShSKU1JU0MsIHVwIHRvIDExLzE5IG9mIHRoZW0g
bWlnaHQgYmUKKwkgKiB1c2VmdWwgYXQgcHJlc2VudC4gU28gZXhwYW5kIHRoaXMgYXJyYXkgdG8g
MTYvMzIgdG8gbGVhdmUgcm9vbS4KKwkgKi8KKwlzdHJ1Y3QgbWNpbmZvX21zciBtY19tc3Jbc2l6
ZW9mKHZvaWQgKikgKiA0XTsKK307CisKKy8qIFJlY292ZXJ5IEFjdGlvbiBmbGFncy4gR2l2aW5n
IHJlY292ZXJ5IHJlc3VsdCBpbmZvcm1hdGlvbiB0byBET00wICovCisKKy8qIFhlbiB0YWtlcyBz
dWNjZXNzZnVsIHJlY292ZXJ5IGFjdGlvbiwgdGhlIGVycm9yIGlzIHJlY292ZXJlZCAqLworI2Rl
ZmluZSBSRUNfQUNUSU9OX1JFQ09WRVJFRCAoMHgxIDw8IDApCisvKiBObyBhY3Rpb24gaXMgcGVy
Zm9ybWVkIGJ5IFhFTiAqLworI2RlZmluZSBSRUNfQUNUSU9OX05PTkUgKDB4MSA8PCAxKQorLyog
SXQncyBwb3NzaWJsZSBET00wIG1pZ2h0IHRha2UgYWN0aW9uIG93bmVyc2hpcCBpbiBzb21lIGNh
c2UgKi8KKyNkZWZpbmUgUkVDX0FDVElPTl9ORUVEX1JFU0VUICgweDEgPDwgMikKKworLyoKKyAq
IERpZmZlcmVudCBSZWNvdmVyeSBBY3Rpb24gdHlwZXMsIGlmIHRoZSBhY3Rpb24gaXMgcGVyZm9y
bWVkIHN1Y2Nlc3NmdWxseSwKKyAqIFJFQ19BQ1RJT05fUkVDT1ZFUkVEIGZsYWcgd2lsbCBiZSBy
ZXR1cm5lZC4KKyAqLworCisvKiBQYWdlIE9mZmxpbmUgQWN0aW9uICovCisjZGVmaW5lIE1DX0FD
VElPTl9QQUdFX09GRkxJTkUgKDB4MSA8PCAwKQorLyogQ1BVIG9mZmxpbmUgQWN0aW9uICovCisj
ZGVmaW5lIE1DX0FDVElPTl9DUFVfT0ZGTElORSAoMHgxIDw8IDEpCisvKiBMMyBjYWNoZSBkaXNh
YmxlIEFjdGlvbiAqLworI2RlZmluZSBNQ19BQ1RJT05fQ0FDSEVfU0hSSU5LICgweDEgPDwgMikK
KworLyoKKyAqIEJlbG93IGludGVyZmFjZSB1c2VkIGJldHdlZW4gWEVOL0RPTTAgZm9yIHBhc3Np
bmcgWEVOJ3MgcmVjb3ZlcnkgYWN0aW9uCisgKiBpbmZvcm1hdGlvbiB0byBET00wLgorICovCitz
dHJ1Y3QgcGFnZV9vZmZsaW5lX2FjdGlvbiB7CisJLyogUGFyYW1zIGZvciBwYXNzaW5nIHRoZSBv
ZmZsaW5lZCBwYWdlIG51bWJlciB0byBET00wICovCisJdWludDY0X3QgbWZuOworCXVpbnQ2NF90
IHN0YXR1czsKK307CisKK3N0cnVjdCBjcHVfb2ZmbGluZV9hY3Rpb24geworCS8qIFBhcmFtcyBm
b3IgcGFzc2luZyB0aGUgaWRlbnRpdHkgb2YgdGhlIG9mZmxpbmVkIENQVSB0byBET00wICovCisJ
dWludDMyX3QgbWNfc29ja2V0aWQ7CisJdWludDE2X3QgbWNfY29yZWlkOworCXVpbnQxNl90IG1j
X2NvcmVfdGhyZWFkaWQ7Cit9OworCisjZGVmaW5lIE1BWF9VTklPTl9TSVpFIDE2CitzdHJ1Y3Qg
bWNpbmZvX3JlY292ZXJ5IHsKKwlzdHJ1Y3QgbWNpbmZvX2NvbW1vbiBjb21tb247CisJdWludDE2
X3QgbWNfYmFuazsgLyogYmFuayBuciAqLworCXVpbnQ4X3QgYWN0aW9uX2ZsYWdzOworCXVpbnQ4
X3QgYWN0aW9uX3R5cGVzOworCXVuaW9uIHsKKwkJc3RydWN0IHBhZ2Vfb2ZmbGluZV9hY3Rpb24g
cGFnZV9yZXRpcmU7CisJCXN0cnVjdCBjcHVfb2ZmbGluZV9hY3Rpb24gY3B1X29mZmxpbmU7CisJ
CXVpbnQ4X3QgcGFkW01BWF9VTklPTl9TSVpFXTsKKwl9IGFjdGlvbl9pbmZvOworfTsKKworCisj
ZGVmaW5lIE1DSU5GT19NQVhTSVpFIDc2OAorc3RydWN0IG1jX2luZm8geworCS8qIE51bWJlciBv
ZiBtY2luZm9fKiBlbnRyaWVzIGluIG1pX2RhdGEgKi8KKwl1aW50MzJfdCBtaV9uZW50cmllczsK
Kwl1aW50MzJfdCBmbGFnczsKKwl1aW50NjRfdCBtaV9kYXRhWyhNQ0lORk9fTUFYU0laRSAtIDEp
IC8gOF07Cit9OworREVGSU5FX0dVRVNUX0hBTkRMRV9TVFJVQ1QobWNfaW5mbyk7CisKKyNkZWZp
bmUgX19NQ19NU1JfQVJSQVlTSVpFIDgKKyNkZWZpbmUgX19NQ19NU1JfTUNHQ0FQIDAKKyNkZWZp
bmUgX19NQ19OTVNSUyAxCisjZGVmaW5lIE1DX05DQVBTIDcKK3N0cnVjdCBtY2luZm9fbG9naWNh
bF9jcHUgeworCXVpbnQzMl90IG1jX2NwdW5yOworCXVpbnQzMl90IG1jX2NoaXBpZDsKKwl1aW50
MTZfdCBtY19jb3JlaWQ7CisJdWludDE2X3QgbWNfdGhyZWFkaWQ7CisJdWludDMyX3QgbWNfYXBp
Y2lkOworCXVpbnQzMl90IG1jX2NsdXN0ZXJpZDsKKwl1aW50MzJfdCBtY19uY29yZXM7CisJdWlu
dDMyX3QgbWNfbmNvcmVzX2FjdGl2ZTsKKwl1aW50MzJfdCBtY19udGhyZWFkczsKKwl1aW50MzJf
dCBtY19jcHVpZF9sZXZlbDsKKwl1aW50MzJfdCBtY19mYW1pbHk7CisJdWludDMyX3QgbWNfdmVu
ZG9yOworCXVpbnQzMl90IG1jX21vZGVsOworCXVpbnQzMl90IG1jX3N0ZXA7CisJY2hhciBtY192
ZW5kb3JpZFsxNl07CisJY2hhciBtY19icmFuZGlkWzY0XTsKKwl1aW50MzJfdCBtY19jcHVfY2Fw
c1tNQ19OQ0FQU107CisJdWludDMyX3QgbWNfY2FjaGVfc2l6ZTsKKwl1aW50MzJfdCBtY19jYWNo
ZV9hbGlnbm1lbnQ7CisJdWludDMyX3QgbWNfbm1zcnZhbHM7CisJc3RydWN0IG1jaW5mb19tc3Ig
bWNfbXNydmFsdWVzW19fTUNfTVNSX0FSUkFZU0laRV07Cit9OworREVGSU5FX0dVRVNUX0hBTkRM
RV9TVFJVQ1QobWNpbmZvX2xvZ2ljYWxfY3B1KTsKKworLyoKKyAqIFByb3RvdHlwZToKKyAqICAg
IHVpbnQzMl90IHg4Nl9tY2luZm9fbmVudHJpZXMoc3RydWN0IG1jX2luZm8gKm1pKTsKKyAqLwor
I2RlZmluZSB4ODZfbWNpbmZvX25lbnRyaWVzKF9taSkgICAgXAorCSgoX21pKS0+bWlfbmVudHJp
ZXMpCisvKgorICogUHJvdG90eXBlOgorICogICAgc3RydWN0IG1jaW5mb19jb21tb24gKng4Nl9t
Y2luZm9fZmlyc3Qoc3RydWN0IG1jX2luZm8gKm1pKTsKKyAqLworI2RlZmluZSB4ODZfbWNpbmZv
X2ZpcnN0KF9taSkgICAgICAgXAorCSgoc3RydWN0IG1jaW5mb19jb21tb24gKikoX21pKS0+bWlf
ZGF0YSkKKy8qCisgKiBQcm90b3R5cGU6CisgKiAgICBzdHJ1Y3QgbWNpbmZvX2NvbW1vbiAqeDg2
X21jaW5mb19uZXh0KHN0cnVjdCBtY2luZm9fY29tbW9uICptaWMpOworICovCisjZGVmaW5lIHg4
Nl9tY2luZm9fbmV4dChfbWljKSAgICAgICBcCisJKChzdHJ1Y3QgbWNpbmZvX2NvbW1vbiAqKSgo
dWludDhfdCAqKShfbWljKSArIChfbWljKS0+c2l6ZSkpCisKKy8qCisgKiBQcm90b3R5cGU6Cisg
KiAgICB2b2lkIHg4Nl9tY2luZm9fbG9va3VwKHZvaWQgKnJldCwgc3RydWN0IG1jX2luZm8gKm1p
LCB1aW50MTZfdCB0eXBlKTsKKyAqLworc3RhdGljIGlubGluZSB2b2lkIHg4Nl9tY2luZm9fbG9v
a3VwKHN0cnVjdCBtY2luZm9fY29tbW9uICoqcmV0LAorCQkJCSAgICAgc3RydWN0IG1jX2luZm8g
Km1pLCB1aW50MTZfdCB0eXBlKQoreworCXVpbnQzMl90IGk7CisJc3RydWN0IG1jaW5mb19jb21t
b24gKm1pYzsKKwlib29sIGZvdW5kID0gMDsKKworCWlmICghcmV0IHx8ICFtaSkKKwkJcmV0dXJu
OworCisJbWljID0geDg2X21jaW5mb19maXJzdChtaSk7CisJZm9yIChpID0gMDsgaSA8IHg4Nl9t
Y2luZm9fbmVudHJpZXMobWkpOyBpKyspIHsKKwkJaWYgKG1pYy0+dHlwZSA9PSB0eXBlKSB7CisJ
CQlmb3VuZCA9IDE7CisJCQlicmVhazsKKwkJfQorCQltaWMgPSB4ODZfbWNpbmZvX25leHQobWlj
KTsKKwl9CisKKwkqcmV0ID0gZm91bmQgPyBtaWMgOiBOVUxMOworfQorCisvKgorICogRmV0Y2gg
bWFjaGluZSBjaGVjayBkYXRhIGZyb20gaHlwZXJ2aXNvci4KKyAqLworI2RlZmluZSBYRU5fTUNf
ZmV0Y2gJCTEKK3N0cnVjdCB4ZW5fbWNfZmV0Y2ggeworCS8qCisJICogSU46IFhFTl9NQ19OT05V
UkdFTlQsIFhFTl9NQ19VUkdFTlQsCisJICogWEVOX01DX0FDSyBpZiBhY2sna2luZyBhbiBlYXJs
aWVyIGZldGNoCisJICogT1VUOiBYRU5fTUNfT0ssIFhFTl9NQ19GRVRDSEFJTEVELCBYRU5fTUNf
Tk9EQVRBCisJICovCisJdWludDMyX3QgZmxhZ3M7CisJdWludDMyX3QgX3BhZDA7CisJLyogT1VU
OiBpZCBmb3IgYWNrLCBJTjogaWQgd2UgYXJlIGFjaydpbmcgKi8KKwl1aW50NjRfdCBmZXRjaF9p
ZDsKKworCS8qIE9VVCB2YXJpYWJsZXMuICovCisJR1VFU1RfSEFORExFKG1jX2luZm8pIGRhdGE7
Cit9OworREVGSU5FX0dVRVNUX0hBTkRMRV9TVFJVQ1QoeGVuX21jX2ZldGNoKTsKKworCisvKgor
ICogVGhpcyB0ZWxscyB0aGUgaHlwZXJ2aXNvciB0byBub3RpZnkgYSBEb21VIGFib3V0IHRoZSBt
YWNoaW5lIGNoZWNrIGVycm9yCisgKi8KKyNkZWZpbmUgWEVOX01DX25vdGlmeWRvbWFpbgkyCitz
dHJ1Y3QgeGVuX21jX25vdGlmeWRvbWFpbiB7CisJLyogSU4gdmFyaWFibGVzICovCisJdWludDE2
X3QgbWNfZG9taWQ7IC8qIFRoZSB1bnByaXZpbGVnZWQgZG9tYWluIHRvIG5vdGlmeSAqLworCXVp
bnQxNl90IG1jX3ZjcHVpZDsgLyogVGhlIHZjcHUgaW4gbWNfZG9taWQgdG8gbm90aWZ5ICovCisK
KwkvKiBJTi9PVVQgdmFyaWFibGVzICovCisJdWludDMyX3QgZmxhZ3M7Cit9OworREVGSU5FX0dV
RVNUX0hBTkRMRV9TVFJVQ1QoeGVuX21jX25vdGlmeWRvbWFpbik7CisKKyNkZWZpbmUgWEVOX01D
X3BoeXNjcHVpbmZvCTMKK3N0cnVjdCB4ZW5fbWNfcGh5c2NwdWluZm8geworCS8qIElOL09VVCAq
LworCXVpbnQzMl90IG5jcHVzOworCXVpbnQzMl90IF9wYWQwOworCS8qIE9VVCAqLworCUdVRVNU
X0hBTkRMRShtY2luZm9fbG9naWNhbF9jcHUpIGluZm87Cit9OworCisjZGVmaW5lIFhFTl9NQ19t
c3JpbmplY3QJNAorI2RlZmluZSBNQ19NU1JJTkpfTUFYTVNSUwk4CitzdHJ1Y3QgeGVuX21jX21z
cmluamVjdCB7CisJLyogSU4gKi8KKwl1aW50MzJfdCBtY2lual9jcHVucjsgLyogdGFyZ2V0IHBy
b2Nlc3NvciBpZCAqLworCXVpbnQzMl90IG1jaW5qX2ZsYWdzOyAvKiBzZWUgTUNfTVNSSU5KX0Zf
KiBiZWxvdyAqLworCXVpbnQzMl90IG1jaW5qX2NvdW50OyAvKiAwIC4uIGNvdW50LTEgaW4gYXJy
YXkgYXJlIHZhbGlkICovCisJdWludDMyX3QgX3BhZDA7CisJc3RydWN0IG1jaW5mb19tc3IgbWNp
bmpfbXNyW01DX01TUklOSl9NQVhNU1JTXTsKK307CisKKy8qIEZsYWdzIGZvciBtY2lual9mbGFn
cyBhYm92ZTsgYml0cyAxNi0zMSBhcmUgcmVzZXJ2ZWQgKi8KKyNkZWZpbmUgTUNfTVNSSU5KX0Zf
SU5URVJQT1NFCTB4MQorCisjZGVmaW5lIFhFTl9NQ19tY2VpbmplY3QJNQorc3RydWN0IHhlbl9t
Y19tY2VpbmplY3QgeworCXVuc2lnbmVkIGludCBtY2VpbmpfY3B1bnI7IC8qIHRhcmdldCBwcm9j
ZXNzb3IgaWQgKi8KK307CisKK3N0cnVjdCB4ZW5fbWMgeworCXVpbnQzMl90IGNtZDsKKwl1aW50
MzJfdCBpbnRlcmZhY2VfdmVyc2lvbjsgLyogWEVOX01DQV9JTlRFUkZBQ0VfVkVSU0lPTiAqLwor
CXVuaW9uIHsKKwkJc3RydWN0IHhlbl9tY19mZXRjaCAgICAgICAgbWNfZmV0Y2g7CisJCXN0cnVj
dCB4ZW5fbWNfbm90aWZ5ZG9tYWluIG1jX25vdGlmeWRvbWFpbjsKKwkJc3RydWN0IHhlbl9tY19w
aHlzY3B1aW5mbyAgbWNfcGh5c2NwdWluZm87CisJCXN0cnVjdCB4ZW5fbWNfbXNyaW5qZWN0ICAg
IG1jX21zcmluamVjdDsKKwkJc3RydWN0IHhlbl9tY19tY2VpbmplY3QgICAgbWNfbWNlaW5qZWN0
OworCX0gdTsKK307CitERUZJTkVfR1VFU1RfSEFORExFX1NUUlVDVCh4ZW5fbWMpOworCisjZW5k
aWYgLyogX19BU1NFTUJMWV9fICovCisjZW5kaWYgLyogX19YRU5fUFVCTElDX0FSQ0hfWDg2X01D
QV9IX18gKi8KLS0gCjEuNy4xCgo=

--_002_DE8DF0795D48FD4CA783C40EC8292335146A62SHSMSX101ccrcorpi_--
