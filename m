Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab2DSN3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 09:29:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:19693 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab2DSN3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 09:29:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="132876559"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] Add mcelog support for xen platform
Thread-Topic: [PATCH 1/3] Add mcelog support for xen platform
Thread-Index: Ac0eMGTbbwDu17uMTQ2vQPuvK5oUmg==
Date: Thu, 19 Apr 2012 13:29:06 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC8292335154EFCSHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC8292335154EFCSHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From af4467b6cf0104ce98cc160438d865256c7d5561 Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Fri, 20 Apr 2012 05:08:38 +0800
Subject: [PATCH 1/3] Add mcelog support for xen platform

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
 drivers/xen/mcelog.c                 |  240 ++++++++++++++++++++++++
 include/xen/interface/xen-mca.h      |  336 ++++++++++++++++++++++++++++++=
++++
 6 files changed, 594 insertions(+), 3 deletions(-)
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
index 9424313..0f54241 100644
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
+	  Allow kernel fetching MCE error from Xen platform and
+	  converting it into Linux mcelog format for mcelog tools
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
index 0000000..95ceb5e
--- /dev/null
+++ b/drivers/xen/mcelog.c
@@ -0,0 +1,240 @@
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
+#include <asm/mce.h>
+
+#include <xen/interface/xen.h>
+#include <xen/events.h>
+#include <xen/interface/vcpu.h>
+#include <xen/xen.h>
+#include <asm/xen/hypercall.h>
+#include <asm/xen/hypervisor.h>
+
+#define XEN_MCELOG "xen_mcelog: "
+
+static struct mc_info g_mi;
+static struct mcinfo_logical_cpu *g_physinfo;
+static uint32_t ncpus;
+
+static DEFINE_SPINLOCK(mcelog_lock);
+
+static int convert_log(struct mc_info *mi)
+{
+	struct mcinfo_common *mic;
+	struct mcinfo_global *mc_global;
+	struct mcinfo_bank *mc_bank;
+	struct mce m;
+	uint32_t i;
+
+	mic =3D NULL;
+	x86_mcinfo_lookup(&mic, mi, MC_TYPE_GLOBAL);
+	if (unlikely(!mic)) {
+		pr_warning(XEN_MCELOG "Failed to find global error info\n");
+		return -ENODEV;
+	}
+
+	mce_setup(&m);
+	mc_global =3D (struct mcinfo_global *)mic;
+	m.mcgstatus =3D mc_global->mc_gstatus;
+	m.apicid =3D mc_global->mc_apicid;
+
+	for (i =3D 0; i < ncpus; i++)
+		if (g_physinfo[i].mc_apicid =3D=3D m.apicid)
+			break;
+	if (unlikely(i =3D=3D ncpus)) {
+		pr_warning(XEN_MCELOG "Failed to match cpu with apicid %d\n",
+			   m.apicid);
+		return -ENODEV;
+	}
+
+	m.socketid =3D g_physinfo[i].mc_chipid;
+	m.cpu =3D m.extcpu =3D g_physinfo[i].mc_cpunr;
+	m.cpuvendor =3D (__u8)g_physinfo[i].mc_vendor;
+	m.mcgcap =3D g_physinfo[i].mc_msrvalues[__MC_MSR_MCGCAP].value;
+
+	mic =3D NULL;
+	x86_mcinfo_lookup(&mic, mi, MC_TYPE_BANK);
+	if (unlikely(!mic)) {
+		pr_warning(XEN_MCELOG "Fail to find bank error info\n");
+		return -ENODEV;
+	}
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
+
+	return 0;
+}
+
+static int mc_queue_handle(uint32_t flags)
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
+		if (ret) {
+			pr_err(XEN_MCELOG "Failed to fetch %s error log\n",
+			       (flags =3D=3D XEN_MC_URGENT) ?
+			       "urgnet" : "nonurgent");
+			break;
+		}
+
+		if (mc_op.u.mc_fetch.flags & XEN_MC_NODATA ||
+		    mc_op.u.mc_fetch.flags & XEN_MC_FETCHFAILED)
+			break;
+		else {
+			ret =3D convert_log(&g_mi);
+			if (ret)
+				pr_warning(XEN_MCELOG
+					   "Failed to convert this error log, "
+					   "continue acking it anyway\n");
+
+			mc_op.u.mc_fetch.flags =3D flags | XEN_MC_ACK;
+			ret =3D HYPERVISOR_mca(&mc_op);
+			if (ret) {
+				pr_err(XEN_MCELOG
+				       "Failed to ack previous error log\n");
+				break;
+			}
+		}
+	} while (1);
+
+	spin_unlock_irqrestore(&mcelog_lock, tmp);
+
+	return ret;
+}
+
+/* virq handler for machine check error info*/
+static irqreturn_t xen_mce_interrupt(int irq, void *dev_id)
+{
+	int err;
+
+	/* urgent mc_info */
+	err =3D mc_queue_handle(XEN_MC_URGENT);
+	if (err)
+		pr_err(XEN_MCELOG
+		       "Failed to handle urgent mc_info queue, "
+		       "continue handling nonurgent mc_info queue anyway.\n");
+
+	/* nonurgent mc_info */
+	err =3D mc_queue_handle(XEN_MC_NONURGENT);
+	if (err)
+		pr_err(XEN_MCELOG
+		       "Failed to handle nonurgent mc_info queue.\n");
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
+		pr_err(XEN_MCELOG "Failed to get CPU numbers\n");
+		return ret;
+	}
+
+	/* Fetch each CPU Physical Info for later reference*/
+	ncpus =3D mc_op.u.mc_physcpuinfo.ncpus;
+	g_physinfo =3D kcalloc(ncpus, sizeof(struct mcinfo_logical_cpu),
+			     GFP_KERNEL);
+	if (!g_physinfo)
+		return -ENOMEM;
+	set_xen_guest_handle(mc_op.u.mc_physcpuinfo.info, g_physinfo);
+	ret =3D HYPERVISOR_mca(&mc_op);
+	if (ret) {
+		pr_err(XEN_MCELOG "Failed to get CPU info\n");
+		kfree(g_physinfo);
+		return ret;
+	}
+
+	ret  =3D bind_virq_to_irqhandler(VIRQ_MCA, 0,
+				       xen_mce_interrupt, 0, "mce", NULL);
+	if (ret < 0) {
+		pr_err(XEN_MCELOG "Failed to bind virq\n");
+		kfree(g_physinfo);
+		return ret;
+	}
+
+	return 0;
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

--_002_DE8DF0795D48FD4CA783C40EC8292335154EFCSHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-Add-mcelog-support-for-xen-platform.patch"
Content-Description: 0001-Add-mcelog-support-for-xen-platform.patch
Content-Disposition: attachment;
	filename="0001-Add-mcelog-support-for-xen-platform.patch"; size=20832;
	creation-date="Thu, 19 Apr 2012 13:21:53 GMT";
	modification-date="Thu, 19 Apr 2012 21:16:56 GMT"
Content-Transfer-Encoding: base64

RnJvbSBhZjQ0NjdiNmNmMDEwNGNlOThjYzE2MDQzOGQ4NjUyNTZjN2Q1NTYxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogRnJpLCAyMCBBcHIgMjAxMiAwNTowODozOCArMDgwMApTdWJqZWN0OiBbUEFUQ0ggMS8z
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
ICB8ICAgIDEgKwogZHJpdmVycy94ZW4vbWNlbG9nLmMgICAgICAgICAgICAgICAgIHwgIDI0MCAr
KysrKysrKysrKysrKysrKysrKysrKysKIGluY2x1ZGUveGVuL2ludGVyZmFjZS94ZW4tbWNhLmgg
ICAgICB8ICAzMzYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogNiBmaWxlcyBj
aGFuZ2VkLCA1OTQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKIGNyZWF0ZSBtb2RlIDEw
MDY0NCBkcml2ZXJzL3hlbi9tY2Vsb2cuYwogY3JlYXRlIG1vZGUgMTAwNjQ0IGluY2x1ZGUveGVu
L2ludGVyZmFjZS94ZW4tbWNhLmgKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS94
ZW4vaHlwZXJjYWxsLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS94ZW4vaHlwZXJjYWxsLmgKaW5k
ZXggNTcyODg1Mi4uNTljMjI2ZCAxMDA2NDQKLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20veGVu
L2h5cGVyY2FsbC5oCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3hlbi9oeXBlcmNhbGwuaApA
QCAtNDgsNiArNDgsNyBAQAogI2luY2x1ZGUgPHhlbi9pbnRlcmZhY2Uvc2NoZWQuaD4KICNpbmNs
dWRlIDx4ZW4vaW50ZXJmYWNlL3BoeXNkZXYuaD4KICNpbmNsdWRlIDx4ZW4vaW50ZXJmYWNlL3Bs
YXRmb3JtLmg+CisjaW5jbHVkZSA8eGVuL2ludGVyZmFjZS94ZW4tbWNhLmg+CiAKIC8qCiAgKiBU
aGUgaHlwZXJjYWxsIGFzbXMgaGF2ZSB0byBtZWV0IHNldmVyYWwgY29uc3RyYWludHM6CkBAIC0z
MDIsNiArMzAzLDEzIEBAIEhZUEVSVklTT1Jfc2V0X3RpbWVyX29wKHU2NCB0aW1lb3V0KQogfQog
CiBzdGF0aWMgaW5saW5lIGludAorSFlQRVJWSVNPUl9tY2Eoc3RydWN0IHhlbl9tYyAqbWNfb3Ap
Cit7CisJbWNfb3AtPmludGVyZmFjZV92ZXJzaW9uID0gWEVOX01DQV9JTlRFUkZBQ0VfVkVSU0lP
TjsKKwlyZXR1cm4gX2h5cGVyY2FsbDEoaW50LCBtY2EsIG1jX29wKTsKK30KKworc3RhdGljIGlu
bGluZSBpbnQKIEhZUEVSVklTT1JfZG9tMF9vcChzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wICpwbGF0
Zm9ybV9vcCkKIHsKIAlwbGF0Zm9ybV9vcC0+aW50ZXJmYWNlX3ZlcnNpb24gPSBYRU5QRl9JTlRF
UkZBQ0VfVkVSU0lPTjsKZGlmZiAtLWdpdCBhL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYyBiL2Fy
Y2gveDg2L3hlbi9lbmxpZ2h0ZW4uYwppbmRleCA0ZjUxYmViLi4xNTYyOGQ0IDEwMDY0NAotLS0g
YS9hcmNoL3g4Ni94ZW4vZW5saWdodGVuLmMKKysrIGIvYXJjaC94ODYveGVuL2VubGlnaHRlbi5j
CkBAIC0zMjksOSArMzI5LDcgQEAgc3RhdGljIHZvaWQgX19pbml0IHhlbl9pbml0X2NwdWlkX21h
c2sodm9pZCkKIAl1bnNpZ25lZCBpbnQgeHNhdmVfbWFzazsKIAogCWNwdWlkX2xlYWYxX2VkeF9t
YXNrID0KLQkJfigoMSA8PCBYODZfRkVBVFVSRV9NQ0UpICB8ICAvKiBkaXNhYmxlIE1DRSAqLwot
CQkgICgxIDw8IFg4Nl9GRUFUVVJFX01DQSkgIHwgIC8qIGRpc2FibGUgTUNBICovCi0JCSAgKDEg
PDwgWDg2X0ZFQVRVUkVfTVRSUikgfCAgLyogZGlzYWJsZSBNVFJSICovCisJCX4oKDEgPDwgWDg2
X0ZFQVRVUkVfTVRSUikgfCAgLyogZGlzYWJsZSBNVFJSICovCiAJCSAgKDEgPDwgWDg2X0ZFQVRV
UkVfQUNDKSk7ICAgLyogdGhlcm1hbCBtb25pdG9yaW5nICovCiAKIAlpZiAoIXhlbl9pbml0aWFs
X2RvbWFpbigpKQpkaWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4vS2NvbmZpZyBiL2RyaXZlcnMveGVu
L0tjb25maWcKaW5kZXggOTQyNDMxMy4uMGY1NDI0MSAxMDA2NDQKLS0tIGEvZHJpdmVycy94ZW4v
S2NvbmZpZworKysgYi9kcml2ZXJzL3hlbi9LY29uZmlnCkBAIC0xOTQsNCArMTk0LDEyIEBAIGNv
bmZpZyBYRU5fQUNQSV9QUk9DRVNTT1IKICAgICAgICAgICBtb2R1bGUgd2lsbCBiZSBjYWxsZWQg
eGVuX2FjcGlfcHJvY2Vzc29yICBJZiB5b3UgZG8gbm90IGtub3cgd2hhdCB0byBjaG9vc2UsCiAg
ICAgICAgICAgc2VsZWN0IE0gaGVyZS4gSWYgdGhlIENQVUZSRVEgZHJpdmVycyBhcmUgYnVpbHQg
aW4sIHNlbGVjdCBZIGhlcmUuCiAKK2NvbmZpZyBYRU5fTUNFX0xPRworCWJvb2wgIlhlbiBwbGF0
Zm9ybSBtY2Vsb2ciCisJZGVwZW5kcyBvbiBYRU5fRE9NMCAmJiBYODZfNjQgJiYgWDg2X01DRQor
CWRlZmF1bHQgbgorCWhlbHAKKwkgIEFsbG93IGtlcm5lbCBmZXRjaGluZyBNQ0UgZXJyb3IgZnJv
bSBYZW4gcGxhdGZvcm0gYW5kCisJICBjb252ZXJ0aW5nIGl0IGludG8gTGludXggbWNlbG9nIGZv
cm1hdCBmb3IgbWNlbG9nIHRvb2xzCisKIGVuZG1lbnUKZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVu
L01ha2VmaWxlIGIvZHJpdmVycy94ZW4vTWFrZWZpbGUKaW5kZXggOWFkYzViZS4uMWQzZTc2MyAx
MDA2NDQKLS0tIGEvZHJpdmVycy94ZW4vTWFrZWZpbGUKKysrIGIvZHJpdmVycy94ZW4vTWFrZWZp
bGUKQEAgLTE0LDYgKzE0LDcgQEAgb2JqLSQoQ09ORklHX1hFTl9HTlRERVYpCQkrPSB4ZW4tZ250
ZGV2Lm8KIG9iai0kKENPTkZJR19YRU5fR1JBTlRfREVWX0FMTE9DKQkrPSB4ZW4tZ250YWxsb2Mu
bwogb2JqLSQoQ09ORklHX1hFTkZTKQkJCSs9IHhlbmZzLwogb2JqLSQoQ09ORklHX1hFTl9TWVNf
SFlQRVJWSVNPUikJKz0gc3lzLWh5cGVydmlzb3Iubworb2JqLSQoQ09ORklHX1hFTl9NQ0VfTE9H
KQkJKz0gbWNlbG9nLm8KIG9iai0kKENPTkZJR19YRU5fUFZIVk0pCQkJKz0gcGxhdGZvcm0tcGNp
Lm8KIG9iai0kKENPTkZJR19YRU5fVE1FTSkJCQkrPSB0bWVtLm8KIG9iai0kKENPTkZJR19TV0lP
VExCX1hFTikJCSs9IHN3aW90bGIteGVuLm8KZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVuL21jZWxv
Zy5jIGIvZHJpdmVycy94ZW4vbWNlbG9nLmMKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAw
MDAwMC4uOTVjZWI1ZQotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZlcnMveGVuL21jZWxvZy5jCkBA
IC0wLDAgKzEsMjQwIEBACisvKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCisgKiBtY2Vsb2cuYworICog
RHJpdmVyIGZvciByZWNlaXZpbmcgYW5kIHRyYW5zZmVycmluZyBtYWNoaW5lIGNoZWNrIGVycm9y
IGluZm9tYXRpb24KKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTIgSW50ZWwgQ29ycG9yYXRpb24K
KyAqIEF1dGhvcjogTGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+CisgKiBBdXRo
b3I6IEppYW5nLCBZdW5ob25nIDx5dW5ob25nLmppYW5nQGludGVsLmNvbT4KKyAqIEF1dGhvcjog
S2UsIExpcGluZyA8bGlwaW5nLmtlQGludGVsLmNvbT4KKyAqCisgKiBUaGlzIHByb2dyYW0gaXMg
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
QVJFLgorICovCisKKyNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KKyNpbmNsdWRlIDxsaW51eC9p
bml0Lmg+CisjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4KKyNpbmNsdWRlIDxsaW51eC9rZXJuZWwu
aD4KKyNpbmNsdWRlIDxsaW51eC9zbGFiLmg+CisjaW5jbHVkZSA8YXNtL21jZS5oPgorCisjaW5j
bHVkZSA8eGVuL2ludGVyZmFjZS94ZW4uaD4KKyNpbmNsdWRlIDx4ZW4vZXZlbnRzLmg+CisjaW5j
bHVkZSA8eGVuL2ludGVyZmFjZS92Y3B1Lmg+CisjaW5jbHVkZSA8eGVuL3hlbi5oPgorI2luY2x1
ZGUgPGFzbS94ZW4vaHlwZXJjYWxsLmg+CisjaW5jbHVkZSA8YXNtL3hlbi9oeXBlcnZpc29yLmg+
CisKKyNkZWZpbmUgWEVOX01DRUxPRyAieGVuX21jZWxvZzogIgorCitzdGF0aWMgc3RydWN0IG1j
X2luZm8gZ19taTsKK3N0YXRpYyBzdHJ1Y3QgbWNpbmZvX2xvZ2ljYWxfY3B1ICpnX3BoeXNpbmZv
Oworc3RhdGljIHVpbnQzMl90IG5jcHVzOworCitzdGF0aWMgREVGSU5FX1NQSU5MT0NLKG1jZWxv
Z19sb2NrKTsKKworc3RhdGljIGludCBjb252ZXJ0X2xvZyhzdHJ1Y3QgbWNfaW5mbyAqbWkpCit7
CisJc3RydWN0IG1jaW5mb19jb21tb24gKm1pYzsKKwlzdHJ1Y3QgbWNpbmZvX2dsb2JhbCAqbWNf
Z2xvYmFsOworCXN0cnVjdCBtY2luZm9fYmFuayAqbWNfYmFuazsKKwlzdHJ1Y3QgbWNlIG07CisJ
dWludDMyX3QgaTsKKworCW1pYyA9IE5VTEw7CisJeDg2X21jaW5mb19sb29rdXAoJm1pYywgbWks
IE1DX1RZUEVfR0xPQkFMKTsKKwlpZiAodW5saWtlbHkoIW1pYykpIHsKKwkJcHJfd2FybmluZyhY
RU5fTUNFTE9HICJGYWlsZWQgdG8gZmluZCBnbG9iYWwgZXJyb3IgaW5mb1xuIik7CisJCXJldHVy
biAtRU5PREVWOworCX0KKworCW1jZV9zZXR1cCgmbSk7CisJbWNfZ2xvYmFsID0gKHN0cnVjdCBt
Y2luZm9fZ2xvYmFsICopbWljOworCW0ubWNnc3RhdHVzID0gbWNfZ2xvYmFsLT5tY19nc3RhdHVz
OworCW0uYXBpY2lkID0gbWNfZ2xvYmFsLT5tY19hcGljaWQ7CisKKwlmb3IgKGkgPSAwOyBpIDwg
bmNwdXM7IGkrKykKKwkJaWYgKGdfcGh5c2luZm9baV0ubWNfYXBpY2lkID09IG0uYXBpY2lkKQor
CQkJYnJlYWs7CisJaWYgKHVubGlrZWx5KGkgPT0gbmNwdXMpKSB7CisJCXByX3dhcm5pbmcoWEVO
X01DRUxPRyAiRmFpbGVkIHRvIG1hdGNoIGNwdSB3aXRoIGFwaWNpZCAlZFxuIiwKKwkJCSAgIG0u
YXBpY2lkKTsKKwkJcmV0dXJuIC1FTk9ERVY7CisJfQorCisJbS5zb2NrZXRpZCA9IGdfcGh5c2lu
Zm9baV0ubWNfY2hpcGlkOworCW0uY3B1ID0gbS5leHRjcHUgPSBnX3BoeXNpbmZvW2ldLm1jX2Nw
dW5yOworCW0uY3B1dmVuZG9yID0gKF9fdTgpZ19waHlzaW5mb1tpXS5tY192ZW5kb3I7CisJbS5t
Y2djYXAgPSBnX3BoeXNpbmZvW2ldLm1jX21zcnZhbHVlc1tfX01DX01TUl9NQ0dDQVBdLnZhbHVl
OworCisJbWljID0gTlVMTDsKKwl4ODZfbWNpbmZvX2xvb2t1cCgmbWljLCBtaSwgTUNfVFlQRV9C
QU5LKTsKKwlpZiAodW5saWtlbHkoIW1pYykpIHsKKwkJcHJfd2FybmluZyhYRU5fTUNFTE9HICJG
YWlsIHRvIGZpbmQgYmFuayBlcnJvciBpbmZvXG4iKTsKKwkJcmV0dXJuIC1FTk9ERVY7CisJfQor
CisJZG8geworCQlpZiAoKCFtaWMpIHx8IChtaWMtPnNpemUgPT0gMCkgfHwKKwkJICAgIChtaWMt
PnR5cGUgIT0gTUNfVFlQRV9HTE9CQUwgICAmJgorCQkgICAgIG1pYy0+dHlwZSAhPSBNQ19UWVBF
X0JBTksgICAgICYmCisJCSAgICAgbWljLT50eXBlICE9IE1DX1RZUEVfRVhURU5ERUQgJiYKKwkJ
ICAgICBtaWMtPnR5cGUgIT0gTUNfVFlQRV9SRUNPVkVSWSkpCisJCQlicmVhazsKKworCQlpZiAo
bWljLT50eXBlID09IE1DX1RZUEVfQkFOSykgeworCQkJbWNfYmFuayA9IChzdHJ1Y3QgbWNpbmZv
X2JhbmsgKiltaWM7CisJCQltLm1pc2MgPSBtY19iYW5rLT5tY19taXNjOworCQkJbS5zdGF0dXMg
PSBtY19iYW5rLT5tY19zdGF0dXM7CisJCQltLmFkZHIgPSBtY19iYW5rLT5tY19hZGRyOworCQkJ
bS50c2MgPSBtY19iYW5rLT5tY190c2M7CisJCQltLmJhbmsgPSBtY19iYW5rLT5tY19iYW5rOwor
CQkJbS5maW5pc2hlZCA9IDE7CisJCQkvKmxvZyB0aGlzIHJlY29yZCovCisJCQltY2VfbG9nKCZt
KTsKKwkJfQorCQltaWMgPSB4ODZfbWNpbmZvX25leHQobWljKTsKKwl9IHdoaWxlICgxKTsKKwor
CXJldHVybiAwOworfQorCitzdGF0aWMgaW50IG1jX3F1ZXVlX2hhbmRsZSh1aW50MzJfdCBmbGFn
cykKK3sKKwlzdHJ1Y3QgeGVuX21jIG1jX29wOworCWludCByZXQgPSAwOworCXVuc2lnbmVkIGxv
bmcgdG1wOworCisJc3Bpbl9sb2NrX2lycXNhdmUoJm1jZWxvZ19sb2NrLCB0bXApOworCisJbWNf
b3AuY21kID0gWEVOX01DX2ZldGNoOworCW1jX29wLmludGVyZmFjZV92ZXJzaW9uID0gWEVOX01D
QV9JTlRFUkZBQ0VfVkVSU0lPTjsKKwlzZXRfeGVuX2d1ZXN0X2hhbmRsZShtY19vcC51Lm1jX2Zl
dGNoLmRhdGEsICZnX21pKTsKKwlkbyB7CisJCW1jX29wLnUubWNfZmV0Y2guZmxhZ3MgPSBmbGFn
czsKKwkJcmV0ID0gSFlQRVJWSVNPUl9tY2EoJm1jX29wKTsKKwkJaWYgKHJldCkgeworCQkJcHJf
ZXJyKFhFTl9NQ0VMT0cgIkZhaWxlZCB0byBmZXRjaCAlcyBlcnJvciBsb2dcbiIsCisJCQkgICAg
ICAgKGZsYWdzID09IFhFTl9NQ19VUkdFTlQpID8KKwkJCSAgICAgICAidXJnbmV0IiA6ICJub251
cmdlbnQiKTsKKwkJCWJyZWFrOworCQl9CisKKwkJaWYgKG1jX29wLnUubWNfZmV0Y2guZmxhZ3Mg
JiBYRU5fTUNfTk9EQVRBIHx8CisJCSAgICBtY19vcC51Lm1jX2ZldGNoLmZsYWdzICYgWEVOX01D
X0ZFVENIRkFJTEVEKQorCQkJYnJlYWs7CisJCWVsc2UgeworCQkJcmV0ID0gY29udmVydF9sb2co
JmdfbWkpOworCQkJaWYgKHJldCkKKwkJCQlwcl93YXJuaW5nKFhFTl9NQ0VMT0cKKwkJCQkJICAg
IkZhaWxlZCB0byBjb252ZXJ0IHRoaXMgZXJyb3IgbG9nLCAiCisJCQkJCSAgICJjb250aW51ZSBh
Y2tpbmcgaXQgYW55d2F5XG4iKTsKKworCQkJbWNfb3AudS5tY19mZXRjaC5mbGFncyA9IGZsYWdz
IHwgWEVOX01DX0FDSzsKKwkJCXJldCA9IEhZUEVSVklTT1JfbWNhKCZtY19vcCk7CisJCQlpZiAo
cmV0KSB7CisJCQkJcHJfZXJyKFhFTl9NQ0VMT0cKKwkJCQkgICAgICAgIkZhaWxlZCB0byBhY2sg
cHJldmlvdXMgZXJyb3IgbG9nXG4iKTsKKwkJCQlicmVhazsKKwkJCX0KKwkJfQorCX0gd2hpbGUg
KDEpOworCisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmbWNlbG9nX2xvY2ssIHRtcCk7CisKKwly
ZXR1cm4gcmV0OworfQorCisvKiB2aXJxIGhhbmRsZXIgZm9yIG1hY2hpbmUgY2hlY2sgZXJyb3Ig
aW5mbyovCitzdGF0aWMgaXJxcmV0dXJuX3QgeGVuX21jZV9pbnRlcnJ1cHQoaW50IGlycSwgdm9p
ZCAqZGV2X2lkKQoreworCWludCBlcnI7CisKKwkvKiB1cmdlbnQgbWNfaW5mbyAqLworCWVyciA9
IG1jX3F1ZXVlX2hhbmRsZShYRU5fTUNfVVJHRU5UKTsKKwlpZiAoZXJyKQorCQlwcl9lcnIoWEVO
X01DRUxPRworCQkgICAgICAgIkZhaWxlZCB0byBoYW5kbGUgdXJnZW50IG1jX2luZm8gcXVldWUs
ICIKKwkJICAgICAgICJjb250aW51ZSBoYW5kbGluZyBub251cmdlbnQgbWNfaW5mbyBxdWV1ZSBh
bnl3YXkuXG4iKTsKKworCS8qIG5vbnVyZ2VudCBtY19pbmZvICovCisJZXJyID0gbWNfcXVldWVf
aGFuZGxlKFhFTl9NQ19OT05VUkdFTlQpOworCWlmIChlcnIpCisJCXByX2VycihYRU5fTUNFTE9H
CisJCSAgICAgICAiRmFpbGVkIHRvIGhhbmRsZSBub251cmdlbnQgbWNfaW5mbyBxdWV1ZS5cbiIp
OworCisJcmV0dXJuIElSUV9IQU5ETEVEOworfQorCitzdGF0aWMgaW50IGJpbmRfdmlycV9mb3Jf
bWNlKHZvaWQpCit7CisJaW50IHJldDsKKwlzdHJ1Y3QgeGVuX21jIG1jX29wOworCisJbWVtc2V0
KCZtY19vcCwgMCwgc2l6ZW9mKHN0cnVjdCB4ZW5fbWMpKTsKKworCS8qIEZldGNoIHBoeXNpY2Fs
IENQVSBOdW1iZXJzICovCisJbWNfb3AuY21kID0gWEVOX01DX3BoeXNjcHVpbmZvOworCW1jX29w
LmludGVyZmFjZV92ZXJzaW9uID0gWEVOX01DQV9JTlRFUkZBQ0VfVkVSU0lPTjsKKwlzZXRfeGVu
X2d1ZXN0X2hhbmRsZShtY19vcC51Lm1jX3BoeXNjcHVpbmZvLmluZm8sIGdfcGh5c2luZm8pOwor
CXJldCA9IEhZUEVSVklTT1JfbWNhKCZtY19vcCk7CisJaWYgKHJldCkgeworCQlwcl9lcnIoWEVO
X01DRUxPRyAiRmFpbGVkIHRvIGdldCBDUFUgbnVtYmVyc1xuIik7CisJCXJldHVybiByZXQ7CisJ
fQorCisJLyogRmV0Y2ggZWFjaCBDUFUgUGh5c2ljYWwgSW5mbyBmb3IgbGF0ZXIgcmVmZXJlbmNl
Ki8KKwluY3B1cyA9IG1jX29wLnUubWNfcGh5c2NwdWluZm8ubmNwdXM7CisJZ19waHlzaW5mbyA9
IGtjYWxsb2MobmNwdXMsIHNpemVvZihzdHJ1Y3QgbWNpbmZvX2xvZ2ljYWxfY3B1KSwKKwkJCSAg
ICAgR0ZQX0tFUk5FTCk7CisJaWYgKCFnX3BoeXNpbmZvKQorCQlyZXR1cm4gLUVOT01FTTsKKwlz
ZXRfeGVuX2d1ZXN0X2hhbmRsZShtY19vcC51Lm1jX3BoeXNjcHVpbmZvLmluZm8sIGdfcGh5c2lu
Zm8pOworCXJldCA9IEhZUEVSVklTT1JfbWNhKCZtY19vcCk7CisJaWYgKHJldCkgeworCQlwcl9l
cnIoWEVOX01DRUxPRyAiRmFpbGVkIHRvIGdldCBDUFUgaW5mb1xuIik7CisJCWtmcmVlKGdfcGh5
c2luZm8pOworCQlyZXR1cm4gcmV0OworCX0KKworCXJldCAgPSBiaW5kX3ZpcnFfdG9faXJxaGFu
ZGxlcihWSVJRX01DQSwgMCwKKwkJCQkgICAgICAgeGVuX21jZV9pbnRlcnJ1cHQsIDAsICJtY2Ui
LCBOVUxMKTsKKwlpZiAocmV0IDwgMCkgeworCQlwcl9lcnIoWEVOX01DRUxPRyAiRmFpbGVkIHRv
IGJpbmQgdmlycVxuIik7CisJCWtmcmVlKGdfcGh5c2luZm8pOworCQlyZXR1cm4gcmV0OworCX0K
KworCXJldHVybiAwOworfQorCitzdGF0aWMgaW50IF9faW5pdCBtY2Vsb2dfaW5pdCh2b2lkKQor
eworCS8qIE9ubHkgRE9NMCBpcyByZXNwb25zaWJsZSBmb3IgTUNFIGxvZ2dpbmcgKi8KKwlpZiAo
eGVuX2luaXRpYWxfZG9tYWluKCkpCisJCXJldHVybiBiaW5kX3ZpcnFfZm9yX21jZSgpOworCisJ
cmV0dXJuIC1FTk9ERVY7Cit9CitsYXRlX2luaXRjYWxsKG1jZWxvZ19pbml0KTsKZGlmZiAtLWdp
dCBhL2luY2x1ZGUveGVuL2ludGVyZmFjZS94ZW4tbWNhLmggYi9pbmNsdWRlL3hlbi9pbnRlcmZh
Y2UveGVuLW1jYS5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLmYyNTYxZGIK
LS0tIC9kZXYvbnVsbAorKysgYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2UveGVuLW1jYS5oCkBAIC0w
LDAgKzEsMzM2IEBACisvKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCisgKiBhcmNoLXg4Ni9tY2EuaAor
ICogR3Vlc3QgT1MgbWFjaGluZSBjaGVjayBpbnRlcmZhY2UgdG8geDg2IFhlbi4KKyAqCisgKiBD
b250cmlidXRlZCBieSBBZHZhbmNlZCBNaWNybyBEZXZpY2VzLCBJbmMuCisgKiBBdXRob3I6IENo
cmlzdG9waCBFZ2dlciA8Q2hyaXN0b3BoLkVnZ2VyQGFtZC5jb20+CisgKgorICogVXBkYXRlZCBi
eSBJbnRlbCBDb3Jwb3JhdGlvbgorICogQXV0aG9yOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1
QGludGVsLmNvbT4KKyAqCisgKiBQZXJtaXNzaW9uIGlzIGhlcmVieSBncmFudGVkLCBmcmVlIG9m
IGNoYXJnZSwgdG8gYW55IHBlcnNvbiBvYnRhaW5pbmcgYSBjb3B5CisgKiBvZiB0aGlzIHNvZnR3
YXJlIGFuZCBhc3NvY2lhdGVkIGRvY3VtZW50YXRpb24gZmlsZXMgKHRoZSAiU29mdHdhcmUiKSwg
dG8KKyAqIGRlYWwgaW4gdGhlIFNvZnR3YXJlIHdpdGhvdXQgcmVzdHJpY3Rpb24sIGluY2x1ZGlu
ZyB3aXRob3V0IGxpbWl0YXRpb24gdGhlCisgKiByaWdodHMgdG8gdXNlLCBjb3B5LCBtb2RpZnks
IG1lcmdlLCBwdWJsaXNoLCBkaXN0cmlidXRlLCBzdWJsaWNlbnNlLCBhbmQvb3IKKyAqIHNlbGwg
Y29waWVzIG9mIHRoZSBTb2Z0d2FyZSwgYW5kIHRvIHBlcm1pdCBwZXJzb25zIHRvIHdob20gdGhl
IFNvZnR3YXJlIGlzCisgKiBmdXJuaXNoZWQgdG8gZG8gc28sIHN1YmplY3QgdG8gdGhlIGZvbGxv
d2luZyBjb25kaXRpb25zOgorICoKKyAqIFRoZSBhYm92ZSBjb3B5cmlnaHQgbm90aWNlIGFuZCB0
aGlzIHBlcm1pc3Npb24gbm90aWNlIHNoYWxsIGJlIGluY2x1ZGVkIGluCisgKiBhbGwgY29waWVz
IG9yIHN1YnN0YW50aWFsIHBvcnRpb25zIG9mIHRoZSBTb2Z0d2FyZS4KKyAqCisgKiBUSEUgU09G
VFdBUkUgSVMgUFJPVklERUQgIkFTIElTIiwgV0lUSE9VVCBXQVJSQU5UWSBPRiBBTlkgS0lORCwg
RVhQUkVTUyBPUgorICogSU1QTElFRCwgSU5DTFVESU5HIEJVVCBOT1QgTElNSVRFRCBUTyBUSEUg
V0FSUkFOVElFUyBPRiBNRVJDSEFOVEFCSUxJVFksCisgKiBGSVRORVNTIEZPUiBBIFBBUlRJQ1VM
QVIgUFVSUE9TRSBBTkQgTk9OSU5GUklOR0VNRU5ULiBJTiBOTyBFVkVOVCBTSEFMTCBUSEUKKyAq
IEFVVEhPUlMgT1IgQ09QWVJJR0hUIEhPTERFUlMgQkUgTElBQkxFIEZPUiBBTlkgQ0xBSU0sIERB
TUFHRVMgT1IgT1RIRVIKKyAqIExJQUJJTElUWSwgV0hFVEhFUiBJTiBBTiBBQ1RJT04gT0YgQ09O
VFJBQ1QsIFRPUlQgT1IgT1RIRVJXSVNFLCBBUklTSU5HCisgKiBGUk9NLCBPVVQgT0YgT1IgSU4g
Q09OTkVDVElPTiBXSVRIIFRIRSBTT0ZUV0FSRSBPUiBUSEUgVVNFIE9SIE9USEVSCisgKiBERUFM
SU5HUyBJTiBUSEUgU09GVFdBUkUuCisgKi8KKworI2lmbmRlZiBfX1hFTl9QVUJMSUNfQVJDSF9Y
ODZfTUNBX0hfXworI2RlZmluZSBfX1hFTl9QVUJMSUNfQVJDSF9YODZfTUNBX0hfXworCisvKiBI
eXBlcmNhbGwgKi8KKyNkZWZpbmUgX19IWVBFUlZJU09SX21jYSBfX0hZUEVSVklTT1JfYXJjaF8w
CisKKyNkZWZpbmUgWEVOX01DQV9JTlRFUkZBQ0VfVkVSU0lPTgkweDAxZWNjMDAzCisKKy8qIElO
OiBEb20wIGNhbGxzIGh5cGVyY2FsbCB0byByZXRyaWV2ZSBub251cmdlbnQgZXJyb3IgbG9nIGVu
dHJ5ICovCisjZGVmaW5lIFhFTl9NQ19OT05VUkdFTlQJMHgxCisvKiBJTjogRG9tMCBjYWxscyBo
eXBlcmNhbGwgdG8gcmV0cmlldmUgdXJnZW50IGVycm9yIGxvZyBlbnRyeSAqLworI2RlZmluZSBY
RU5fTUNfVVJHRU5UCQkweDIKKy8qIElOOiBEb20wIGFja25vd2xlZGdlcyBwcmV2aW9zbHktZmV0
Y2hlZCBlcnJvciBsb2cgZW50cnkgKi8KKyNkZWZpbmUgWEVOX01DX0FDSwkJMHg0CisKKy8qIE9V
VDogQWxsIGlzIG9rICovCisjZGVmaW5lIFhFTl9NQ19PSwkJMHgwCisvKiBPVVQ6IERvbWFpbiBj
b3VsZCBub3QgZmV0Y2ggZGF0YS4gKi8KKyNkZWZpbmUgWEVOX01DX0ZFVENIRkFJTEVECTB4MQor
LyogT1VUOiBUaGVyZSB3YXMgbm8gbWFjaGluZSBjaGVjayBkYXRhIHRvIGZldGNoLiAqLworI2Rl
ZmluZSBYRU5fTUNfTk9EQVRBCQkweDIKKworI2lmbmRlZiBfX0FTU0VNQkxZX18KKy8qIHZJUlEg
aW5qZWN0ZWQgdG8gRG9tMCAqLworI2RlZmluZSBWSVJRX01DQSBWSVJRX0FSQ0hfMAorCisvKgor
ICogbWNfaW5mbyBlbnRyeSB0eXBlcworICogbWNhIG1hY2hpbmUgY2hlY2sgaW5mbyBhcmUgcmVj
b3JkZWQgaW4gbWNfaW5mbyBlbnRyaWVzLgorICogd2hlbiBmZXRjaCBtY2EgaW5mbywgaXQgY2Fu
IHVzZSBNQ19UWVBFXy4uLiB0byBkaXN0aW5ndWlzaAorICogZGlmZmVyZW50IG1jYSBpbmZvLgor
ICovCisjZGVmaW5lIE1DX1RZUEVfR0xPQkFMCQkwCisjZGVmaW5lIE1DX1RZUEVfQkFOSwkJMQor
I2RlZmluZSBNQ19UWVBFX0VYVEVOREVECTIKKyNkZWZpbmUgTUNfVFlQRV9SRUNPVkVSWQkzCisK
K3N0cnVjdCBtY2luZm9fY29tbW9uIHsKKwl1aW50MTZfdCB0eXBlOyAvKiBzdHJ1Y3R1cmUgdHlw
ZSAqLworCXVpbnQxNl90IHNpemU7IC8qIHNpemUgb2YgdGhpcyBzdHJ1Y3QgaW4gYnl0ZXMgKi8K
K307CisKKyNkZWZpbmUgTUNfRkxBR19DT1JSRUNUQUJMRQkoMSA8PCAwKQorI2RlZmluZSBNQ19G
TEFHX1VOQ09SUkVDVEFCTEUJKDEgPDwgMSkKKyNkZWZpbmUgTUNfRkxBR19SRUNPVkVSQUJMRQko
MSA8PCAyKQorI2RlZmluZSBNQ19GTEFHX1BPTExFRAkJKDEgPDwgMykKKyNkZWZpbmUgTUNfRkxB
R19SRVNFVAkJKDEgPDwgNCkKKyNkZWZpbmUgTUNfRkxBR19DTUNJCQkoMSA8PCA1KQorI2RlZmlu
ZSBNQ19GTEFHX01DRQkJKDEgPDwgNikKKworLyogY29udGFpbnMgeDg2IGdsb2JhbCBtYyBpbmZv
cm1hdGlvbiAqLworc3RydWN0IG1jaW5mb19nbG9iYWwgeworCXN0cnVjdCBtY2luZm9fY29tbW9u
IGNvbW1vbjsKKworCXVpbnQxNl90IG1jX2RvbWlkOyAvKiBydW5uaW5nIGRvbWFpbiBhdCB0aGUg
dGltZSBpbiBlcnJvciAqLworCXVpbnQxNl90IG1jX3ZjcHVpZDsgLyogdmlydHVhbCBjcHUgc2No
ZWR1bGVkIGZvciBtY19kb21pZCAqLworCXVpbnQzMl90IG1jX3NvY2tldGlkOyAvKiBwaHlzaWNh
bCBzb2NrZXQgb2YgdGhlIHBoeXNpY2FsIGNvcmUgKi8KKwl1aW50MTZfdCBtY19jb3JlaWQ7IC8q
IHBoeXNpY2FsIGltcGFjdGVkIGNvcmUgKi8KKwl1aW50MTZfdCBtY19jb3JlX3RocmVhZGlkOyAv
KiBjb3JlIHRocmVhZCBvZiBwaHlzaWNhbCBjb3JlICovCisJdWludDMyX3QgbWNfYXBpY2lkOwor
CXVpbnQzMl90IG1jX2ZsYWdzOworCXVpbnQ2NF90IG1jX2dzdGF0dXM7IC8qIGdsb2JhbCBzdGF0
dXMgKi8KK307CisKKy8qIGNvbnRhaW5zIHg4NiBiYW5rIG1jIGluZm9ybWF0aW9uICovCitzdHJ1
Y3QgbWNpbmZvX2JhbmsgeworCXN0cnVjdCBtY2luZm9fY29tbW9uIGNvbW1vbjsKKworCXVpbnQx
Nl90IG1jX2Jhbms7IC8qIGJhbmsgbnIgKi8KKwl1aW50MTZfdCBtY19kb21pZDsgLyogZG9tYWlu
IHJlZmVyZW5jZWQgYnkgbWNfYWRkciBpZiB2YWxpZCAqLworCXVpbnQ2NF90IG1jX3N0YXR1czsg
LyogYmFuayBzdGF0dXMgKi8KKwl1aW50NjRfdCBtY19hZGRyOyAvKiBiYW5rIGFkZHJlc3MgKi8K
Kwl1aW50NjRfdCBtY19taXNjOworCXVpbnQ2NF90IG1jX2N0cmwyOworCXVpbnQ2NF90IG1jX3Rz
YzsKK307CisKK3N0cnVjdCBtY2luZm9fbXNyIHsKKwl1aW50NjRfdCByZWc7IC8qIE1TUiAqLwor
CXVpbnQ2NF90IHZhbHVlOyAvKiBNU1IgdmFsdWUgKi8KK307CisKKy8qIGNvbnRhaW5zIG1jIGlu
Zm9ybWF0aW9uIGZyb20gb3RoZXIgb3IgYWRkaXRpb25hbCBtYyBNU1JzICovCitzdHJ1Y3QgbWNp
bmZvX2V4dGVuZGVkIHsKKwlzdHJ1Y3QgbWNpbmZvX2NvbW1vbiBjb21tb247CisJdWludDMyX3Qg
bWNfbXNyczsgLyogTnVtYmVyIG9mIG1zciB3aXRoIHZhbGlkIHZhbHVlcy4gKi8KKwkvKgorCSAq
IEN1cnJlbnRseSBJbnRlbCBleHRlbmRlZCBNU1IgKDMyLzY0KSBpbmNsdWRlIGFsbCBncCByZWdp
c3RlcnMKKwkgKiBhbmQgRShSKUZMQUdTLCBFKFIpSVAsIEUoUilNSVNDLCB1cCB0byAxMS8xOSBv
ZiB0aGVtIG1pZ2h0IGJlCisJICogdXNlZnVsIGF0IHByZXNlbnQuIFNvIGV4cGFuZCB0aGlzIGFy
cmF5IHRvIDE2LzMyIHRvIGxlYXZlIHJvb20uCisJICovCisJc3RydWN0IG1jaW5mb19tc3IgbWNf
bXNyW3NpemVvZih2b2lkICopICogNF07Cit9OworCisvKiBSZWNvdmVyeSBBY3Rpb24gZmxhZ3Mu
IEdpdmluZyByZWNvdmVyeSByZXN1bHQgaW5mb3JtYXRpb24gdG8gRE9NMCAqLworCisvKiBYZW4g
dGFrZXMgc3VjY2Vzc2Z1bCByZWNvdmVyeSBhY3Rpb24sIHRoZSBlcnJvciBpcyByZWNvdmVyZWQg
Ki8KKyNkZWZpbmUgUkVDX0FDVElPTl9SRUNPVkVSRUQgKDB4MSA8PCAwKQorLyogTm8gYWN0aW9u
IGlzIHBlcmZvcm1lZCBieSBYRU4gKi8KKyNkZWZpbmUgUkVDX0FDVElPTl9OT05FICgweDEgPDwg
MSkKKy8qIEl0J3MgcG9zc2libGUgRE9NMCBtaWdodCB0YWtlIGFjdGlvbiBvd25lcnNoaXAgaW4g
c29tZSBjYXNlICovCisjZGVmaW5lIFJFQ19BQ1RJT05fTkVFRF9SRVNFVCAoMHgxIDw8IDIpCisK
Ky8qCisgKiBEaWZmZXJlbnQgUmVjb3ZlcnkgQWN0aW9uIHR5cGVzLCBpZiB0aGUgYWN0aW9uIGlz
IHBlcmZvcm1lZCBzdWNjZXNzZnVsbHksCisgKiBSRUNfQUNUSU9OX1JFQ09WRVJFRCBmbGFnIHdp
bGwgYmUgcmV0dXJuZWQuCisgKi8KKworLyogUGFnZSBPZmZsaW5lIEFjdGlvbiAqLworI2RlZmlu
ZSBNQ19BQ1RJT05fUEFHRV9PRkZMSU5FICgweDEgPDwgMCkKKy8qIENQVSBvZmZsaW5lIEFjdGlv
biAqLworI2RlZmluZSBNQ19BQ1RJT05fQ1BVX09GRkxJTkUgKDB4MSA8PCAxKQorLyogTDMgY2Fj
aGUgZGlzYWJsZSBBY3Rpb24gKi8KKyNkZWZpbmUgTUNfQUNUSU9OX0NBQ0hFX1NIUklOSyAoMHgx
IDw8IDIpCisKKy8qCisgKiBCZWxvdyBpbnRlcmZhY2UgdXNlZCBiZXR3ZWVuIFhFTi9ET00wIGZv
ciBwYXNzaW5nIFhFTidzIHJlY292ZXJ5IGFjdGlvbgorICogaW5mb3JtYXRpb24gdG8gRE9NMC4K
KyAqLworc3RydWN0IHBhZ2Vfb2ZmbGluZV9hY3Rpb24geworCS8qIFBhcmFtcyBmb3IgcGFzc2lu
ZyB0aGUgb2ZmbGluZWQgcGFnZSBudW1iZXIgdG8gRE9NMCAqLworCXVpbnQ2NF90IG1mbjsKKwl1
aW50NjRfdCBzdGF0dXM7Cit9OworCitzdHJ1Y3QgY3B1X29mZmxpbmVfYWN0aW9uIHsKKwkvKiBQ
YXJhbXMgZm9yIHBhc3NpbmcgdGhlIGlkZW50aXR5IG9mIHRoZSBvZmZsaW5lZCBDUFUgdG8gRE9N
MCAqLworCXVpbnQzMl90IG1jX3NvY2tldGlkOworCXVpbnQxNl90IG1jX2NvcmVpZDsKKwl1aW50
MTZfdCBtY19jb3JlX3RocmVhZGlkOworfTsKKworI2RlZmluZSBNQVhfVU5JT05fU0laRSAxNgor
c3RydWN0IG1jaW5mb19yZWNvdmVyeSB7CisJc3RydWN0IG1jaW5mb19jb21tb24gY29tbW9uOwor
CXVpbnQxNl90IG1jX2Jhbms7IC8qIGJhbmsgbnIgKi8KKwl1aW50OF90IGFjdGlvbl9mbGFnczsK
Kwl1aW50OF90IGFjdGlvbl90eXBlczsKKwl1bmlvbiB7CisJCXN0cnVjdCBwYWdlX29mZmxpbmVf
YWN0aW9uIHBhZ2VfcmV0aXJlOworCQlzdHJ1Y3QgY3B1X29mZmxpbmVfYWN0aW9uIGNwdV9vZmZs
aW5lOworCQl1aW50OF90IHBhZFtNQVhfVU5JT05fU0laRV07CisJfSBhY3Rpb25faW5mbzsKK307
CisKKworI2RlZmluZSBNQ0lORk9fTUFYU0laRSA3NjgKK3N0cnVjdCBtY19pbmZvIHsKKwkvKiBO
dW1iZXIgb2YgbWNpbmZvXyogZW50cmllcyBpbiBtaV9kYXRhICovCisJdWludDMyX3QgbWlfbmVu
dHJpZXM7CisJdWludDMyX3QgZmxhZ3M7CisJdWludDY0X3QgbWlfZGF0YVsoTUNJTkZPX01BWFNJ
WkUgLSAxKSAvIDhdOworfTsKK0RFRklORV9HVUVTVF9IQU5ETEVfU1RSVUNUKG1jX2luZm8pOwor
CisjZGVmaW5lIF9fTUNfTVNSX0FSUkFZU0laRSA4CisjZGVmaW5lIF9fTUNfTVNSX01DR0NBUCAw
CisjZGVmaW5lIF9fTUNfTk1TUlMgMQorI2RlZmluZSBNQ19OQ0FQUyA3CitzdHJ1Y3QgbWNpbmZv
X2xvZ2ljYWxfY3B1IHsKKwl1aW50MzJfdCBtY19jcHVucjsKKwl1aW50MzJfdCBtY19jaGlwaWQ7
CisJdWludDE2X3QgbWNfY29yZWlkOworCXVpbnQxNl90IG1jX3RocmVhZGlkOworCXVpbnQzMl90
IG1jX2FwaWNpZDsKKwl1aW50MzJfdCBtY19jbHVzdGVyaWQ7CisJdWludDMyX3QgbWNfbmNvcmVz
OworCXVpbnQzMl90IG1jX25jb3Jlc19hY3RpdmU7CisJdWludDMyX3QgbWNfbnRocmVhZHM7CisJ
dWludDMyX3QgbWNfY3B1aWRfbGV2ZWw7CisJdWludDMyX3QgbWNfZmFtaWx5OworCXVpbnQzMl90
IG1jX3ZlbmRvcjsKKwl1aW50MzJfdCBtY19tb2RlbDsKKwl1aW50MzJfdCBtY19zdGVwOworCWNo
YXIgbWNfdmVuZG9yaWRbMTZdOworCWNoYXIgbWNfYnJhbmRpZFs2NF07CisJdWludDMyX3QgbWNf
Y3B1X2NhcHNbTUNfTkNBUFNdOworCXVpbnQzMl90IG1jX2NhY2hlX3NpemU7CisJdWludDMyX3Qg
bWNfY2FjaGVfYWxpZ25tZW50OworCXVpbnQzMl90IG1jX25tc3J2YWxzOworCXN0cnVjdCBtY2lu
Zm9fbXNyIG1jX21zcnZhbHVlc1tfX01DX01TUl9BUlJBWVNJWkVdOworfTsKK0RFRklORV9HVUVT
VF9IQU5ETEVfU1RSVUNUKG1jaW5mb19sb2dpY2FsX2NwdSk7CisKKy8qCisgKiBQcm90b3R5cGU6
CisgKiAgICB1aW50MzJfdCB4ODZfbWNpbmZvX25lbnRyaWVzKHN0cnVjdCBtY19pbmZvICptaSk7
CisgKi8KKyNkZWZpbmUgeDg2X21jaW5mb19uZW50cmllcyhfbWkpICAgIFwKKwkoKF9taSktPm1p
X25lbnRyaWVzKQorLyoKKyAqIFByb3RvdHlwZToKKyAqICAgIHN0cnVjdCBtY2luZm9fY29tbW9u
ICp4ODZfbWNpbmZvX2ZpcnN0KHN0cnVjdCBtY19pbmZvICptaSk7CisgKi8KKyNkZWZpbmUgeDg2
X21jaW5mb19maXJzdChfbWkpICAgICAgIFwKKwkoKHN0cnVjdCBtY2luZm9fY29tbW9uICopKF9t
aSktPm1pX2RhdGEpCisvKgorICogUHJvdG90eXBlOgorICogICAgc3RydWN0IG1jaW5mb19jb21t
b24gKng4Nl9tY2luZm9fbmV4dChzdHJ1Y3QgbWNpbmZvX2NvbW1vbiAqbWljKTsKKyAqLworI2Rl
ZmluZSB4ODZfbWNpbmZvX25leHQoX21pYykgICAgICAgXAorCSgoc3RydWN0IG1jaW5mb19jb21t
b24gKikoKHVpbnQ4X3QgKikoX21pYykgKyAoX21pYyktPnNpemUpKQorCisvKgorICogUHJvdG90
eXBlOgorICogICAgdm9pZCB4ODZfbWNpbmZvX2xvb2t1cCh2b2lkICpyZXQsIHN0cnVjdCBtY19p
bmZvICptaSwgdWludDE2X3QgdHlwZSk7CisgKi8KK3N0YXRpYyBpbmxpbmUgdm9pZCB4ODZfbWNp
bmZvX2xvb2t1cChzdHJ1Y3QgbWNpbmZvX2NvbW1vbiAqKnJldCwKKwkJCQkgICAgIHN0cnVjdCBt
Y19pbmZvICptaSwgdWludDE2X3QgdHlwZSkKK3sKKwl1aW50MzJfdCBpOworCXN0cnVjdCBtY2lu
Zm9fY29tbW9uICptaWM7CisJYm9vbCBmb3VuZCA9IDA7CisKKwlpZiAoIXJldCB8fCAhbWkpCisJ
CXJldHVybjsKKworCW1pYyA9IHg4Nl9tY2luZm9fZmlyc3QobWkpOworCWZvciAoaSA9IDA7IGkg
PCB4ODZfbWNpbmZvX25lbnRyaWVzKG1pKTsgaSsrKSB7CisJCWlmIChtaWMtPnR5cGUgPT0gdHlw
ZSkgeworCQkJZm91bmQgPSAxOworCQkJYnJlYWs7CisJCX0KKwkJbWljID0geDg2X21jaW5mb19u
ZXh0KG1pYyk7CisJfQorCisJKnJldCA9IGZvdW5kID8gbWljIDogTlVMTDsKK30KKworLyoKKyAq
IEZldGNoIG1hY2hpbmUgY2hlY2sgZGF0YSBmcm9tIGh5cGVydmlzb3IuCisgKi8KKyNkZWZpbmUg
WEVOX01DX2ZldGNoCQkxCitzdHJ1Y3QgeGVuX21jX2ZldGNoIHsKKwkvKgorCSAqIElOOiBYRU5f
TUNfTk9OVVJHRU5ULCBYRU5fTUNfVVJHRU5ULAorCSAqIFhFTl9NQ19BQ0sgaWYgYWNrJ2tpbmcg
YW4gZWFybGllciBmZXRjaAorCSAqIE9VVDogWEVOX01DX09LLCBYRU5fTUNfRkVUQ0hBSUxFRCwg
WEVOX01DX05PREFUQQorCSAqLworCXVpbnQzMl90IGZsYWdzOworCXVpbnQzMl90IF9wYWQwOwor
CS8qIE9VVDogaWQgZm9yIGFjaywgSU46IGlkIHdlIGFyZSBhY2snaW5nICovCisJdWludDY0X3Qg
ZmV0Y2hfaWQ7CisKKwkvKiBPVVQgdmFyaWFibGVzLiAqLworCUdVRVNUX0hBTkRMRShtY19pbmZv
KSBkYXRhOworfTsKK0RFRklORV9HVUVTVF9IQU5ETEVfU1RSVUNUKHhlbl9tY19mZXRjaCk7CisK
KworLyoKKyAqIFRoaXMgdGVsbHMgdGhlIGh5cGVydmlzb3IgdG8gbm90aWZ5IGEgRG9tVSBhYm91
dCB0aGUgbWFjaGluZSBjaGVjayBlcnJvcgorICovCisjZGVmaW5lIFhFTl9NQ19ub3RpZnlkb21h
aW4JMgorc3RydWN0IHhlbl9tY19ub3RpZnlkb21haW4geworCS8qIElOIHZhcmlhYmxlcyAqLwor
CXVpbnQxNl90IG1jX2RvbWlkOyAvKiBUaGUgdW5wcml2aWxlZ2VkIGRvbWFpbiB0byBub3RpZnkg
Ki8KKwl1aW50MTZfdCBtY192Y3B1aWQ7IC8qIFRoZSB2Y3B1IGluIG1jX2RvbWlkIHRvIG5vdGlm
eSAqLworCisJLyogSU4vT1VUIHZhcmlhYmxlcyAqLworCXVpbnQzMl90IGZsYWdzOworfTsKK0RF
RklORV9HVUVTVF9IQU5ETEVfU1RSVUNUKHhlbl9tY19ub3RpZnlkb21haW4pOworCisjZGVmaW5l
IFhFTl9NQ19waHlzY3B1aW5mbwkzCitzdHJ1Y3QgeGVuX21jX3BoeXNjcHVpbmZvIHsKKwkvKiBJ
Ti9PVVQgKi8KKwl1aW50MzJfdCBuY3B1czsKKwl1aW50MzJfdCBfcGFkMDsKKwkvKiBPVVQgKi8K
KwlHVUVTVF9IQU5ETEUobWNpbmZvX2xvZ2ljYWxfY3B1KSBpbmZvOworfTsKKworI2RlZmluZSBY
RU5fTUNfbXNyaW5qZWN0CTQKKyNkZWZpbmUgTUNfTVNSSU5KX01BWE1TUlMJOAorc3RydWN0IHhl
bl9tY19tc3JpbmplY3QgeworCS8qIElOICovCisJdWludDMyX3QgbWNpbmpfY3B1bnI7IC8qIHRh
cmdldCBwcm9jZXNzb3IgaWQgKi8KKwl1aW50MzJfdCBtY2lual9mbGFnczsgLyogc2VlIE1DX01T
UklOSl9GXyogYmVsb3cgKi8KKwl1aW50MzJfdCBtY2lual9jb3VudDsgLyogMCAuLiBjb3VudC0x
IGluIGFycmF5IGFyZSB2YWxpZCAqLworCXVpbnQzMl90IF9wYWQwOworCXN0cnVjdCBtY2luZm9f
bXNyIG1jaW5qX21zcltNQ19NU1JJTkpfTUFYTVNSU107Cit9OworCisvKiBGbGFncyBmb3IgbWNp
bmpfZmxhZ3MgYWJvdmU7IGJpdHMgMTYtMzEgYXJlIHJlc2VydmVkICovCisjZGVmaW5lIE1DX01T
UklOSl9GX0lOVEVSUE9TRQkweDEKKworI2RlZmluZSBYRU5fTUNfbWNlaW5qZWN0CTUKK3N0cnVj
dCB4ZW5fbWNfbWNlaW5qZWN0IHsKKwl1bnNpZ25lZCBpbnQgbWNlaW5qX2NwdW5yOyAvKiB0YXJn
ZXQgcHJvY2Vzc29yIGlkICovCit9OworCitzdHJ1Y3QgeGVuX21jIHsKKwl1aW50MzJfdCBjbWQ7
CisJdWludDMyX3QgaW50ZXJmYWNlX3ZlcnNpb247IC8qIFhFTl9NQ0FfSU5URVJGQUNFX1ZFUlNJ
T04gKi8KKwl1bmlvbiB7CisJCXN0cnVjdCB4ZW5fbWNfZmV0Y2ggICAgICAgIG1jX2ZldGNoOwor
CQlzdHJ1Y3QgeGVuX21jX25vdGlmeWRvbWFpbiBtY19ub3RpZnlkb21haW47CisJCXN0cnVjdCB4
ZW5fbWNfcGh5c2NwdWluZm8gIG1jX3BoeXNjcHVpbmZvOworCQlzdHJ1Y3QgeGVuX21jX21zcmlu
amVjdCAgICBtY19tc3JpbmplY3Q7CisJCXN0cnVjdCB4ZW5fbWNfbWNlaW5qZWN0ICAgIG1jX21j
ZWluamVjdDsKKwl9IHU7Cit9OworREVGSU5FX0dVRVNUX0hBTkRMRV9TVFJVQ1QoeGVuX21jKTsK
KworI2VuZGlmIC8qIF9fQVNTRU1CTFlfXyAqLworI2VuZGlmIC8qIF9fWEVOX1BVQkxJQ19BUkNI
X1g4Nl9NQ0FfSF9fICovCi0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC8292335154EFCSHSMSX101ccrcorpi_--
