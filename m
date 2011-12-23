Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab1LWKXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:23:37 -0500
Received: from mga14.intel.com ([143.182.124.37]:51536 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab1LWKXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:23:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="50055368"
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
Subject: [PATCH 01/10] Add mcelog support from xen platform
Thread-Topic: [PATCH 01/10] Add mcelog support from xen platform
Thread-Index: AczBXNo5kd/dViAgSKaxIwYWg4rVzQ==
Date: Fri, 23 Dec 2011 10:23:03 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923359699@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923359699SHSMSX101ccrcorpint_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923359699SHSMSX101ccrcorpint_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 0e8de1ce0f13aa34aa6013e6a387ae5be78031ca Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Tue, 6 Dec 2011 18:08:12 +0800
Subject: [PATCH 01/10] Add mcelog support from xen platform

This patch backport from Jeremy's pvops commit a5ed1f3dae179158e385e9371462=
dd65d5e125c5,
which in turn backport from previous xen DOM0(2.6.18) cs: 75e5bfa7fbdc

When a MCE/CMCI error happens (or by polling), the related error
information will be sent to privileged pv-ops domain by XEN. This
patch will help to fetch the xen-logged information by hypercall
and then convert XEN-format log into Linux format MCELOG. It makes
using current available mcelog tools for native Linux possible.

With this patch, after mce/cmci error log information is sent to
pv-ops guest, Running mcelog tools in the guest, you will get same
detailed decoded mce information as in Native Linux.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
Signed-off-by: Ke, Liping <liping.ke@intel.com>
Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/xen/hypercall.h |    8 +
 arch/x86/xen/enlighten.c             |    8 +-
 drivers/xen/Kconfig                  |    8 +
 drivers/xen/Makefile                 |    1 +
 drivers/xen/mcelog.c                 |  217 +++++++++++++++++
 include/xen/interface/xen-mca.h      |  429 ++++++++++++++++++++++++++++++=
++++
 6 files changed, 667 insertions(+), 4 deletions(-)
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
index 9306320..b073e4c 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -242,14 +242,14 @@ static void __init xen_init_cpuid_mask(void)
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
 		cpuid_leaf1_edx_mask &=3D
-			~((1 << X86_FEATURE_APIC) |  /* disable local APIC */
+			~((1 << X86_FEATURE_MCE)  |  /* disable MCE */
+			  (1 << X86_FEATURE_MCA)  |  /* disable MCA */
+			  (1 << X86_FEATURE_APIC) |  /* disable local APIC */
 			  (1 << X86_FEATURE_ACPI));  /* disable ACPI */
 	ax =3D 1;
 	xen_cpuid(&ax, &bx, &cx, &dx);
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index e8fb85f..eb2a327 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -117,6 +117,14 @@ config XEN_SYS_HYPERVISOR
 	 virtual environment, /sys/hypervisor will still be present,
 	 but will have no xen contents.
=20
+config XEN_MCE_LOG
+	bool "Xen platform mcelog"
+	depends on XEN_DOM0 && X86_64 && X86_MCE
+	default y
+	help
+	  Allow kernel fetching mce log from xen platform and
+	  converting it into linux mcelog format for mcelog tools
+
 config ACPI_PROCESSOR_XEN
 	tristate
 	depends on XEN_DOM0 && ACPI_PROCESSOR && CPU_FREQ
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index d42da53..405cce9 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_XEN_GNTDEV)		+=3D xen-gntdev.o
 obj-$(CONFIG_XEN_GRANT_DEV_ALLOC)	+=3D xen-gntalloc.o
 obj-$(CONFIG_XENFS)			+=3D xenfs/
 obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+=3D sys-hypervisor.o
+obj-$(CONFIG_XEN_MCE_LOG)		+=3D mcelog.o
 obj-$(CONFIG_XEN_PLATFORM_PCI)		+=3D xen-platform-pci.o
 obj-$(CONFIG_XEN_TMEM)			+=3D tmem.o
 obj-$(CONFIG_SWIOTLB_XEN)		+=3D swiotlb-xen.o
diff --git a/drivers/xen/mcelog.c b/drivers/xen/mcelog.c
new file mode 100644
index 0000000..892ca7b
--- /dev/null
+++ b/drivers/xen/mcelog.c
@@ -0,0 +1,217 @@
+/*************************************************************************=
*****
+ * mcelog.c
+ * Add Machine Check event Logging support in DOM0
+ *
+ * Driver for receiving and logging machine check event
+ *
+ * Copyright (c) 2008, 2009 Intel Corporation
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
+static mc_info_t *g_mi;
+static mcinfo_logical_cpu_t *g_physinfo;
+static uint32_t ncpus;
+
+static int convert_log(struct mc_info *mi)
+{
+	struct mcinfo_common *mic =3D NULL;
+	struct mcinfo_global *mc_global;
+	struct mcinfo_bank *mc_bank;
+	struct mce m;
+	int i, found =3D 0;
+
+	x86_mcinfo_lookup(&mic, mi, MC_TYPE_GLOBAL);
+	WARN_ON(!mic);
+
+	mce_setup(&m);
+	mc_global =3D (struct mcinfo_global *)mic;
+	m.mcgstatus =3D mc_global->mc_gstatus;
+	m.apicid =3D mc_global->mc_apicid;
+	for (i =3D 0; i < ncpus; i++) {
+		if (g_physinfo[i].mc_apicid =3D=3D m.apicid) {
+			found =3D 1;
+			break;
+		}
+	}
+	WARN_ON(!found);
+
+	m.socketid =3D g_physinfo[i].mc_chipid;
+	m.cpu =3D m.extcpu =3D g_physinfo[i].mc_cpunr;
+	m.cpuvendor =3D (__u8)g_physinfo[i].mc_vendor;
+	m.mcgcap =3D g_physinfo[i].mc_msrvalues[0].value;
+	x86_mcinfo_lookup(&mic, mi, MC_TYPE_BANK);
+	do {
+		if (mic =3D=3D NULL || mic->size =3D=3D 0)
+			break;
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
+/*pv_ops domain mce virq handler, logging physical mce error info*/
+static irqreturn_t mce_dom_interrupt(int irq, void *dev_id)
+{
+	xen_mc_t mc_op;
+	int result =3D 0;
+
+	mc_op.cmd =3D XEN_MC_fetch;
+	mc_op.interface_version =3D XEN_MCA_INTERFACE_VERSION;
+	set_xen_guest_handle(mc_op.u.mc_fetch.data, g_mi);
+urgent:
+	mc_op.u.mc_fetch.flags =3D XEN_MC_URGENT;
+	result =3D HYPERVISOR_mca(&mc_op);
+	if (result || mc_op.u.mc_fetch.flags & XEN_MC_NODATA ||
+			mc_op.u.mc_fetch.flags & XEN_MC_FETCHFAILED)
+		goto nonurgent;
+	else {
+		result =3D convert_log(g_mi);
+		if (result)
+			goto end;
+		/* After fetching the error event log entry from DOM0,
+		 * we need to dec the refcnt and release the entry.
+		 * The entry is reserved and inc refcnt when filling
+		 * the error log entry.
+		 */
+		mc_op.u.mc_fetch.flags =3D XEN_MC_URGENT | XEN_MC_ACK;
+		result =3D HYPERVISOR_mca(&mc_op);
+		goto urgent;
+	}
+nonurgent:
+	mc_op.u.mc_fetch.flags =3D XEN_MC_NONURGENT;
+	result =3D HYPERVISOR_mca(&mc_op);
+	if (result || mc_op.u.mc_fetch.flags & XEN_MC_NODATA ||
+			mc_op.u.mc_fetch.flags & XEN_MC_FETCHFAILED)
+		goto end;
+	else {
+		result =3D convert_log(g_mi);
+		if (result)
+			goto end;
+		/* After fetching the error event log entry from DOM0,
+		 * we need to dec the refcnt and release the entry. The
+		 * entry is reserved and inc refcnt when filling the
+		 * error log entry.
+		 */
+		mc_op.u.mc_fetch.flags =3D XEN_MC_NONURGENT | XEN_MC_ACK;
+		result =3D HYPERVISOR_mca(&mc_op);
+		goto nonurgent;
+	}
+end:
+	return IRQ_HANDLED;
+}
+
+static int bind_virq_for_mce(void)
+{
+	int ret;
+	xen_mc_t mc_op;
+
+	g_mi =3D kmalloc(sizeof(struct mc_info), GFP_KERNEL);
+
+	if (!g_mi)
+		return -ENOMEM;
+
+	/* Fetch physical CPU Numbers */
+	mc_op.cmd =3D XEN_MC_physcpuinfo;
+	mc_op.interface_version =3D XEN_MCA_INTERFACE_VERSION;
+	set_xen_guest_handle(mc_op.u.mc_physcpuinfo.info, g_physinfo);
+	ret =3D HYPERVISOR_mca(&mc_op);
+	if (ret) {
+		printk(KERN_ERR "MCE_DOM0_LOG: Fail to get physical CPU numbers\n");
+		kfree(g_mi);
+		return ret;
+	}
+
+	/* Fetch each CPU Physical Info for later reference*/
+	ncpus =3D mc_op.u.mc_physcpuinfo.ncpus;
+	g_physinfo =3D kmalloc(sizeof(struct mcinfo_logical_cpu)*ncpus,
+					GFP_KERNEL);
+	if (!g_physinfo) {
+		kfree(g_mi);
+		return -ENOMEM;
+	}
+	set_xen_guest_handle(mc_op.u.mc_physcpuinfo.info, g_physinfo);
+	ret =3D HYPERVISOR_mca(&mc_op);
+	if (ret) {
+		printk(KERN_ERR "MCE_DOM0_LOG: Fail to get physical CPUs info\n");
+		kfree(g_mi);
+		kfree(g_physinfo);
+		return ret;
+	}
+
+	ret  =3D bind_virq_to_irqhandler(VIRQ_MCA, 0,
+		mce_dom_interrupt, 0, "mce", NULL);
+
+	if (ret < 0) {
+		printk(KERN_ERR "MCE_DOM0_LOG: bind_virq for DOM0 failed\n");
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
+	return 0;
+}
+
+
+static void __exit mcelog_cleanup(void)
+{
+	kfree(g_mi);
+	kfree(g_physinfo);
+}
+module_init(mcelog_init);
+module_exit(mcelog_cleanup);
+
+MODULE_LICENSE("GPL");
diff --git a/include/xen/interface/xen-mca.h b/include/xen/interface/xen-mc=
a.h
new file mode 100644
index 0000000..f31fdab
--- /dev/null
+++ b/include/xen/interface/xen-mca.h
@@ -0,0 +1,429 @@
+/*************************************************************************=
*****
+ * arch-x86/mca.h
+ *
+ * Contributed by Advanced Micro Devices, Inc.
+ * Author: Christoph Egger <Christoph.Egger@amd.com>
+ *
+ * Guest OS machine check interface to x86 Xen.
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
+/* Full MCA functionality has the following Usecases from the guest side:
+ *
+ * Must have's:
+ * 1. Dom0 and DomU register machine check trap callback handlers
+ *    (already done via "set_trap_table" hypercall)
+ * 2. Dom0 registers machine check event callback handler
+ *    (doable via EVTCHNOP_bind_virq)
+ * 3. Dom0 and DomU fetches machine check data
+ * 4. Dom0 wants Xen to notify a DomU
+ * 5. Dom0 gets DomU ID from physical address
+ * 6. Dom0 wants Xen to kill DomU (already done for "xm destroy")
+ *
+ * Nice to have's:
+ * 7. Dom0 wants Xen to deactivate a physical CPU
+ *    This is better done as separate task, physical CPU hotplugging,
+ *    and hypercall(s) should be sysctl's
+ * 8. Page migration proposed from Xen NUMA work, where Dom0 can tell Xen =
to
+ *    move a DomU (or Dom0 itself) away from a malicious page
+ *    producing correctable errors.
+ * 9. offlining physical page:
+ *    Xen free's and never re-uses a certain physical page.
+ * 10. Testfacility: Allow Dom0 to write values into machine check MSR's
+ *     and tell Xen to trigger a machine check
+ */
+
+#ifndef __XEN_PUBLIC_ARCH_X86_MCA_H__
+#define __XEN_PUBLIC_ARCH_X86_MCA_H__
+
+/* Hypercall */
+#define __HYPERVISOR_mca __HYPERVISOR_arch_0
+
+/*
+ * The xen-unstable repo has interface version 0x03000001; out interface
+ * is incompatible with that and any future minor revisions, so we
+ * choose a different version number range that is numerically less
+ * than that used in xen-unstable.
+ */
+#define XEN_MCA_INTERFACE_VERSION 0x01ecc003
+
+/* IN: Dom0 calls hypercall to retrieve nonurgent error log entry */
+#define XEN_MC_NONURGENT  0x0001
+/* IN: Dom0/DomU calls hypercall to retrieve urgent error log entry */
+#define XEN_MC_URGENT     0x0002
+/* IN: Dom0 acknowledges previosly-fetched error log entry */
+#define XEN_MC_ACK        0x0004
+
+/* OUT: All is ok */
+#define XEN_MC_OK           0x0
+/* OUT: Domain could not fetch data. */
+#define XEN_MC_FETCHFAILED  0x1
+/* OUT: There was no machine check data to fetch. */
+#define XEN_MC_NODATA       0x2
+/* OUT: Between notification time and this hypercall an other
+ *  (most likely) correctable error happened. The fetched data,
+ *  does not match the original machine check data. */
+#define XEN_MC_NOMATCH      0x4
+
+/* OUT: DomU did not register MC NMI handler. Try something else. */
+#define XEN_MC_CANNOTHANDLE 0x8
+/* OUT: Notifying DomU failed. Retry later or try something else. */
+#define XEN_MC_NOTDELIVERED 0x10
+/* Note, XEN_MC_CANNOTHANDLE and XEN_MC_NOTDELIVERED are mutually exclusiv=
e. */
+
+
+#ifndef __ASSEMBLY__
+
+#define VIRQ_MCA VIRQ_ARCH_0 /* G. (DOM0) Machine Check Architecture */
+
+/*
+ * Machine Check Architecure:
+ * structs are read-only and used to report all kinds of
+ * correctable and uncorrectable errors detected by the HW.
+ * Dom0 and DomU: register a handler to get notified.
+ * Dom0 only: Correctable errors are reported via VIRQ_MCA
+ */
+#define MC_TYPE_GLOBAL          0
+#define MC_TYPE_BANK            1
+#define MC_TYPE_EXTENDED        2
+#define MC_TYPE_RECOVERY        3
+
+struct mcinfo_common {
+	uint16_t type;      /* structure type */
+	uint16_t size;      /* size of this struct in bytes */
+};
+
+
+#define MC_FLAG_CORRECTABLE     (1 << 0)
+#define MC_FLAG_UNCORRECTABLE   (1 << 1)
+#define MC_FLAG_RECOVERABLE	(1 << 2)
+#define MC_FLAG_POLLED		(1 << 3)
+#define MC_FLAG_RESET		(1 << 4)
+#define MC_FLAG_CMCI		(1 << 5)
+#define MC_FLAG_MCE		(1 << 6)
+/* contains global x86 mc information */
+struct mcinfo_global {
+	struct mcinfo_common common;
+
+	/* running domain at the time in error (most likely
+	 * the impacted one) */
+	uint16_t mc_domid;
+	uint16_t mc_vcpuid; /* virtual cpu scheduled for mc_domid */
+	uint32_t mc_socketid; /* physical socket of the physical core */
+	uint16_t mc_coreid; /* physical impacted core */
+	uint16_t mc_core_threadid; /* core thread of physical core */
+	uint32_t mc_apicid;
+	uint32_t mc_flags;
+	uint64_t mc_gstatus; /* global status */
+};
+
+/* contains bank local x86 mc information */
+struct mcinfo_bank {
+	struct mcinfo_common common;
+
+	uint16_t mc_bank; /* bank nr */
+	uint16_t mc_domid; /* Usecase 5: domain referenced by mc_addr on
+			* privileged pv-ops dom and if mc_addr is valid.
+			* Never valid on DomU. */
+	uint64_t mc_status; /* bank status */
+	uint64_t mc_addr;   /* bank address, only valid
+					 * if addr bit is set in mc_status */
+	uint64_t mc_misc;
+	uint64_t mc_ctrl2;
+	uint64_t mc_tsc;
+};
+
+
+struct mcinfo_msr {
+	uint64_t reg;   /* MSR */
+	uint64_t value; /* MSR value */
+};
+
+/* contains mc information from other
+ * or additional mc MSRs */
+struct mcinfo_extended {
+	struct mcinfo_common common;
+
+	/* You can fill up to five registers.
+	 * If you need more, then use this structure
+	 * multiple times. */
+
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
+/* Different Recovery Action types, if the action is performed successfull=
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
+/* Below interface used between XEN/DOM0 for passing XEN's recovery action
+ * information to DOM0.
+ * usage Senario: After offlining broken page, XEN might pass its page off=
line
+ * recovery action result to DOM0. DOM0 will save the information in
+ * non-volatile memory for further proactive actions, such as offlining th=
e
+ * easy broken page earlier when doing next reboot.
+*/
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
+	/* Recovery Action Flags defined above such as REC_ACTION_DONE */
+	uint8_t action_flags;
+	/* Recovery Action types defined above such as MC_ACTION_PAGE_OFFLINE */
+	uint8_t action_types;
+	/* In future if more than one recovery action permitted per error bank,
+	 * a mcinfo_recovery data array will be returned
+	 */
+	union {
+		struct page_offline_action page_retire;
+		struct cpu_offline_action cpu_offline;
+		uint8_t pad[MAX_UNION_SIZE];
+	} action_info;
+};
+
+
+#define MCINFO_HYPERCALLSIZE	1024
+#define MCINFO_MAXSIZE		768
+
+struct mc_info {
+	/* Number of mcinfo_* entries in mi_data */
+	uint32_t mi_nentries;
+	uint32_t _pad0;
+	uint64_t mi_data[(MCINFO_MAXSIZE - 1) / 8];
+};
+typedef struct mc_info mc_info_t;
+DEFINE_GUEST_HANDLE_STRUCT(mc_info);
+
+#define __MC_MSR_ARRAYSIZE 8
+#define __MC_NMSRS 1
+#define MC_NCAPS	7	/* 7 CPU feature flag words */
+#define MC_CAPS_STD_EDX	0	/* cpuid level 0x00000001 (%edx) */
+#define MC_CAPS_AMD_EDX	1	/* cpuid level 0x80000001 (%edx) */
+#define MC_CAPS_TM	2	/* cpuid level 0x80860001 (TransMeta) */
+#define MC_CAPS_LINUX	3	/* Linux-defined */
+#define MC_CAPS_STD_ECX	4	/* cpuid level 0x00000001 (%ecx) */
+#define MC_CAPS_VIA	5	/* cpuid level 0xc0000001 */
+#define MC_CAPS_AMD_ECX	6	/* cpuid level 0x80000001 (%ecx) */
+
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
+	int32_t mc_cpuid_level;
+	uint32_t mc_family;
+	uint32_t mc_vendor;
+	uint32_t mc_model;
+	uint32_t mc_step;
+	char mc_vendorid[16];
+	char mc_brandid[64];
+	uint32_t mc_cpu_caps[MC_NCAPS];
+	uint32_t mc_cache_size;
+	uint32_t mc_cache_alignment;
+	int32_t mc_nmsrvals;
+	struct mcinfo_msr mc_msrvalues[__MC_MSR_ARRAYSIZE];
+};
+typedef struct mcinfo_logical_cpu mcinfo_logical_cpu_t;
+DEFINE_GUEST_HANDLE_STRUCT(mcinfo_logical_cpu);
+
+
+/*
+ * OS's should use these instead of writing their own lookup function
+ * each with its own bugs and drawbacks.
+ * We use macros instead of static inline functions to allow guests
+ * to include this header in assembly files (*.S).
+ */
+/* Prototype:
+ *    uint32_t x86_mcinfo_nentries(struct mc_info *mi);
+ */
+#define x86_mcinfo_nentries(_mi)    \
+    ((_mi)->mi_nentries)
+/* Prototype:
+ *    struct mcinfo_common *x86_mcinfo_first(struct mc_info *mi);
+ */
+#define x86_mcinfo_first(_mi)       \
+    ((struct mcinfo_common *)(_mi)->mi_data)
+/* Prototype:
+ *    struct mcinfo_common *x86_mcinfo_next(struct mcinfo_common *mic);
+ */
+#define x86_mcinfo_next(_mic)       \
+    ((struct mcinfo_common *)((uint8_t *)(_mic) + (_mic)->size))
+
+/* Prototype:
+ *    void x86_mcinfo_lookup(void *ret, struct mc_info *mi, uint16_t type)=
;
+ */
+
+static inline void x86_mcinfo_lookup
+	(struct mcinfo_common **ret, struct mc_info *mi, uint16_t type)
+{
+	uint32_t found =3D 0, i;
+	struct mcinfo_common *mic;
+
+	*ret =3D NULL;
+	if (!mi)
+		return;
+	mic =3D x86_mcinfo_first(mi);
+
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
+/* Usecase 1
+ * Register machine check trap callback handler
+ *    (already done via "set_trap_table" hypercall)
+ */
+
+/* Usecase 2
+ * Dom0 registers machine check event callback handler
+ * done by EVTCHNOP_bind_virq
+ */
+
+/* Usecase 3
+ * Fetch machine check data from hypervisor.
+ * Note, this hypercall is special, because both Dom0 and DomU must use th=
is.
+ */
+#define XEN_MC_fetch            1
+struct xen_mc_fetch {
+    /* IN/OUT variables.
+	 * IN: XEN_MC_NONURGENT, XEN_MC_URGENT,
+	 * XEN_MC_ACK if ack'king an earlier fetch
+	 * OUT: XEN_MC_OK, XEN_MC_FETCHAILED,
+	 * XEN_MC_NODATA, XEN_MC_NOMATCH
+	*/
+	uint32_t flags;
+	uint32_t _pad0;
+	/* OUT: id for ack, IN: id we are ack'ing */
+	uint64_t fetch_id;
+
+	/* OUT variables. */
+	GUEST_HANDLE(mc_info) data;
+};
+typedef struct xen_mc_fetch xen_mc_fetch_t;
+DEFINE_GUEST_HANDLE_STRUCT(xen_mc_fetch);
+
+
+/* Usecase 4
+ * This tells the hypervisor to notify a DomU about the machine check erro=
r
+ */
+#define XEN_MC_notifydomain     2
+struct xen_mc_notifydomain {
+	/* IN variables. */
+	uint16_t mc_domid;/* The unprivileged domain to notify. */
+	uint16_t mc_vcpuid;/* The vcpu in mc_domid to notify.
+			* Usually echo'd value from the fetch hypercall. */
+
+	/* IN/OUT variables. */
+	uint32_t flags;
+
+/* OUT: XEN_MC_OK, XEN_MC_CANNOTHANDLE, XEN_MC_NOTDELIVERED, XEN_MC_NOMATC=
H */
+};
+typedef struct xen_mc_notifydomain xen_mc_notifydomain_t;
+DEFINE_GUEST_HANDLE_STRUCT(xen_mc_notifydomain);
+
+#define XEN_MC_physcpuinfo 3
+struct xen_mc_physcpuinfo {
+	/* IN/OUT */
+	uint32_t ncpus;
+	uint32_t _pad0;
+	/* OUT */
+	GUEST_HANDLE(mcinfo_logical_cpu) info;
+};
+
+#define XEN_MC_msrinject    4
+#define MC_MSRINJ_MAXMSRS       8
+struct xen_mc_msrinject {
+	/* IN */
+	uint32_t mcinj_cpunr;/* target processor id */
+	uint32_t mcinj_flags;/* see MC_MSRINJ_F_* below */
+	uint32_t mcinj_count;/* 0 .. count-1 in array are valid */
+	uint32_t _pad0;
+	struct mcinfo_msr mcinj_msr[MC_MSRINJ_MAXMSRS];
+};
+
+/* Flags for mcinj_flags above; bits 16-31 are reserved */
+#define MC_MSRINJ_F_INTERPOSE   0x1
+
+#define XEN_MC_mceinject    5
+struct xen_mc_mceinject {
+	unsigned int mceinj_cpunr;      /* target processor id */
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
+typedef struct xen_mc xen_mc_t;
+DEFINE_GUEST_HANDLE_STRUCT(xen_mc);
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __XEN_PUBLIC_ARCH_X86_MCA_H__ */
--=20
1.6.5.6

--_002_DE8DF0795D48FD4CA783C40EC82923359699SHSMSX101ccrcorpint_
Content-Type: application/octet-stream;
	name="0001-Add-mcelog-support-from-xen-platform.patch"
Content-Description: 0001-Add-mcelog-support-from-xen-platform.patch
Content-Disposition: attachment;
	filename="0001-Add-mcelog-support-from-xen-platform.patch"; size=25075;
	creation-date="Wed, 14 Dec 2011 15:20:15 GMT";
	modification-date="Wed, 14 Dec 2011 15:03:34 GMT"
Content-Transfer-Encoding: base64

RnJvbSAwZThkZTFjZTBmMTNhYTM0YWE2MDEzZTZhMzg3YWU1YmU3ODAzMWNhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBUdWUsIDYgRGVjIDIwMTEgMTg6MDg6MTIgKzA4MDAKU3ViamVjdDogW1BBVENIIDAxLzEw
XSBBZGQgbWNlbG9nIHN1cHBvcnQgZnJvbSB4ZW4gcGxhdGZvcm0KClRoaXMgcGF0Y2ggYmFja3Bv
cnQgZnJvbSBKZXJlbXkncyBwdm9wcyBjb21taXQgYTVlZDFmM2RhZTE3OTE1OGUzODVlOTM3MTQ2
MmRkNjVkNWUxMjVjNSwKd2hpY2ggaW4gdHVybiBiYWNrcG9ydCBmcm9tIHByZXZpb3VzIHhlbiBE
T00wKDIuNi4xOCkgY3M6IDc1ZTViZmE3ZmJkYwoKV2hlbiBhIE1DRS9DTUNJIGVycm9yIGhhcHBl
bnMgKG9yIGJ5IHBvbGxpbmcpLCB0aGUgcmVsYXRlZCBlcnJvcgppbmZvcm1hdGlvbiB3aWxsIGJl
IHNlbnQgdG8gcHJpdmlsZWdlZCBwdi1vcHMgZG9tYWluIGJ5IFhFTi4gVGhpcwpwYXRjaCB3aWxs
IGhlbHAgdG8gZmV0Y2ggdGhlIHhlbi1sb2dnZWQgaW5mb3JtYXRpb24gYnkgaHlwZXJjYWxsCmFu
ZCB0aGVuIGNvbnZlcnQgWEVOLWZvcm1hdCBsb2cgaW50byBMaW51eCBmb3JtYXQgTUNFTE9HLiBJ
dCBtYWtlcwp1c2luZyBjdXJyZW50IGF2YWlsYWJsZSBtY2Vsb2cgdG9vbHMgZm9yIG5hdGl2ZSBM
aW51eCBwb3NzaWJsZS4KCldpdGggdGhpcyBwYXRjaCwgYWZ0ZXIgbWNlL2NtY2kgZXJyb3IgbG9n
IGluZm9ybWF0aW9uIGlzIHNlbnQgdG8KcHYtb3BzIGd1ZXN0LCBSdW5uaW5nIG1jZWxvZyB0b29s
cyBpbiB0aGUgZ3Vlc3QsIHlvdSB3aWxsIGdldCBzYW1lCmRldGFpbGVkIGRlY29kZWQgbWNlIGlu
Zm9ybWF0aW9uIGFzIGluIE5hdGl2ZSBMaW51eC4KClNpZ25lZC1vZmYtYnk6IExpdSwgSmluc29u
ZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBLZSwgTGlwaW5nIDxsaXBp
bmcua2VAaW50ZWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBKaWFuZywgWXVuaG9uZyA8eXVuaG9uZy5q
aWFuZ0BpbnRlbC5jb20+ClNpZ25lZC1vZmYtYnk6IEplcmVteSBGaXR6aGFyZGluZ2UgPGplcmVt
eS5maXR6aGFyZGluZ2VAY2l0cml4LmNvbT4KLS0tCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS94ZW4v
aHlwZXJjYWxsLmggfCAgICA4ICsKIGFyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYyAgICAgICAgICAg
ICB8ICAgIDggKy0KIGRyaXZlcnMveGVuL0tjb25maWcgICAgICAgICAgICAgICAgICB8ICAgIDgg
KwogZHJpdmVycy94ZW4vTWFrZWZpbGUgICAgICAgICAgICAgICAgIHwgICAgMSArCiBkcml2ZXJz
L3hlbi9tY2Vsb2cuYyAgICAgICAgICAgICAgICAgfCAgMjE3ICsrKysrKysrKysrKysrKysrCiBp
bmNsdWRlL3hlbi9pbnRlcmZhY2UveGVuLW1jYS5oICAgICAgfCAgNDI5ICsrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysKIDYgZmlsZXMgY2hhbmdlZCwgNjY3IGluc2VydGlvbnMoKyks
IDQgZGVsZXRpb25zKC0pCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy94ZW4vbWNlbG9nLmMK
IGNyZWF0ZSBtb2RlIDEwMDY0NCBpbmNsdWRlL3hlbi9pbnRlcmZhY2UveGVuLW1jYS5oCgpkaWZm
IC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20veGVuL2h5cGVyY2FsbC5oIGIvYXJjaC94ODYv
aW5jbHVkZS9hc20veGVuL2h5cGVyY2FsbC5oCmluZGV4IDU3Mjg4NTIuLjU5YzIyNmQgMTAwNjQ0
Ci0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3hlbi9oeXBlcmNhbGwuaAorKysgYi9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS94ZW4vaHlwZXJjYWxsLmgKQEAgLTQ4LDYgKzQ4LDcgQEAKICNpbmNsdWRl
IDx4ZW4vaW50ZXJmYWNlL3NjaGVkLmg+CiAjaW5jbHVkZSA8eGVuL2ludGVyZmFjZS9waHlzZGV2
Lmg+CiAjaW5jbHVkZSA8eGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oPgorI2luY2x1ZGUgPHhlbi9p
bnRlcmZhY2UveGVuLW1jYS5oPgogCiAvKgogICogVGhlIGh5cGVyY2FsbCBhc21zIGhhdmUgdG8g
bWVldCBzZXZlcmFsIGNvbnN0cmFpbnRzOgpAQCAtMzAyLDYgKzMwMywxMyBAQCBIWVBFUlZJU09S
X3NldF90aW1lcl9vcCh1NjQgdGltZW91dCkKIH0KIAogc3RhdGljIGlubGluZSBpbnQKK0hZUEVS
VklTT1JfbWNhKHN0cnVjdCB4ZW5fbWMgKm1jX29wKQoreworCW1jX29wLT5pbnRlcmZhY2VfdmVy
c2lvbiA9IFhFTl9NQ0FfSU5URVJGQUNFX1ZFUlNJT047CisJcmV0dXJuIF9oeXBlcmNhbGwxKGlu
dCwgbWNhLCBtY19vcCk7Cit9CisKK3N0YXRpYyBpbmxpbmUgaW50CiBIWVBFUlZJU09SX2RvbTBf
b3Aoc3RydWN0IHhlbl9wbGF0Zm9ybV9vcCAqcGxhdGZvcm1fb3ApCiB7CiAJcGxhdGZvcm1fb3At
PmludGVyZmFjZV92ZXJzaW9uID0gWEVOUEZfSU5URVJGQUNFX1ZFUlNJT047CmRpZmYgLS1naXQg
YS9hcmNoL3g4Ni94ZW4vZW5saWdodGVuLmMgYi9hcmNoL3g4Ni94ZW4vZW5saWdodGVuLmMKaW5k
ZXggOTMwNjMyMC4uYjA3M2U0YyAxMDA2NDQKLS0tIGEvYXJjaC94ODYveGVuL2VubGlnaHRlbi5j
CisrKyBiL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYwpAQCAtMjQyLDE0ICsyNDIsMTQgQEAgc3Rh
dGljIHZvaWQgX19pbml0IHhlbl9pbml0X2NwdWlkX21hc2sodm9pZCkKIAl1bnNpZ25lZCBpbnQg
eHNhdmVfbWFzazsKIAogCWNwdWlkX2xlYWYxX2VkeF9tYXNrID0KLQkJfigoMSA8PCBYODZfRkVB
VFVSRV9NQ0UpICB8ICAvKiBkaXNhYmxlIE1DRSAqLwotCQkgICgxIDw8IFg4Nl9GRUFUVVJFX01D
QSkgIHwgIC8qIGRpc2FibGUgTUNBICovCi0JCSAgKDEgPDwgWDg2X0ZFQVRVUkVfTVRSUikgfCAg
LyogZGlzYWJsZSBNVFJSICovCisJCX4oKDEgPDwgWDg2X0ZFQVRVUkVfTVRSUikgfCAgLyogZGlz
YWJsZSBNVFJSICovCiAJCSAgKDEgPDwgWDg2X0ZFQVRVUkVfQUNDKSk7ICAgLyogdGhlcm1hbCBt
b25pdG9yaW5nICovCiAKIAlpZiAoIXhlbl9pbml0aWFsX2RvbWFpbigpKQogCQljcHVpZF9sZWFm
MV9lZHhfbWFzayAmPQotCQkJfigoMSA8PCBYODZfRkVBVFVSRV9BUElDKSB8ICAvKiBkaXNhYmxl
IGxvY2FsIEFQSUMgKi8KKwkJCX4oKDEgPDwgWDg2X0ZFQVRVUkVfTUNFKSAgfCAgLyogZGlzYWJs
ZSBNQ0UgKi8KKwkJCSAgKDEgPDwgWDg2X0ZFQVRVUkVfTUNBKSAgfCAgLyogZGlzYWJsZSBNQ0Eg
Ki8KKwkJCSAgKDEgPDwgWDg2X0ZFQVRVUkVfQVBJQykgfCAgLyogZGlzYWJsZSBsb2NhbCBBUElD
ICovCiAJCQkgICgxIDw8IFg4Nl9GRUFUVVJFX0FDUEkpKTsgIC8qIGRpc2FibGUgQUNQSSAqLwog
CWF4ID0gMTsKIAl4ZW5fY3B1aWQoJmF4LCAmYngsICZjeCwgJmR4KTsKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMveGVuL0tjb25maWcgYi9kcml2ZXJzL3hlbi9LY29uZmlnCmluZGV4IGU4ZmI4NWYuLmVi
MmEzMjcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMveGVuL0tjb25maWcKKysrIGIvZHJpdmVycy94ZW4v
S2NvbmZpZwpAQCAtMTE3LDYgKzExNywxNCBAQCBjb25maWcgWEVOX1NZU19IWVBFUlZJU09SCiAJ
IHZpcnR1YWwgZW52aXJvbm1lbnQsIC9zeXMvaHlwZXJ2aXNvciB3aWxsIHN0aWxsIGJlIHByZXNl
bnQsCiAJIGJ1dCB3aWxsIGhhdmUgbm8geGVuIGNvbnRlbnRzLgogCitjb25maWcgWEVOX01DRV9M
T0cKKwlib29sICJYZW4gcGxhdGZvcm0gbWNlbG9nIgorCWRlcGVuZHMgb24gWEVOX0RPTTAgJiYg
WDg2XzY0ICYmIFg4Nl9NQ0UKKwlkZWZhdWx0IHkKKwloZWxwCisJICBBbGxvdyBrZXJuZWwgZmV0
Y2hpbmcgbWNlIGxvZyBmcm9tIHhlbiBwbGF0Zm9ybSBhbmQKKwkgIGNvbnZlcnRpbmcgaXQgaW50
byBsaW51eCBtY2Vsb2cgZm9ybWF0IGZvciBtY2Vsb2cgdG9vbHMKKwogY29uZmlnIEFDUElfUFJP
Q0VTU09SX1hFTgogCXRyaXN0YXRlCiAJZGVwZW5kcyBvbiBYRU5fRE9NMCAmJiBBQ1BJX1BST0NF
U1NPUiAmJiBDUFVfRlJFUQpkaWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4vTWFrZWZpbGUgYi9kcml2
ZXJzL3hlbi9NYWtlZmlsZQppbmRleCBkNDJkYTUzLi40MDVjY2U5IDEwMDY0NAotLS0gYS9kcml2
ZXJzL3hlbi9NYWtlZmlsZQorKysgYi9kcml2ZXJzL3hlbi9NYWtlZmlsZQpAQCAtMTQsNiArMTQs
NyBAQCBvYmotJChDT05GSUdfWEVOX0dOVERFVikJCSs9IHhlbi1nbnRkZXYubwogb2JqLSQoQ09O
RklHX1hFTl9HUkFOVF9ERVZfQUxMT0MpCSs9IHhlbi1nbnRhbGxvYy5vCiBvYmotJChDT05GSUdf
WEVORlMpCQkJKz0geGVuZnMvCiBvYmotJChDT05GSUdfWEVOX1NZU19IWVBFUlZJU09SKQkrPSBz
eXMtaHlwZXJ2aXNvci5vCitvYmotJChDT05GSUdfWEVOX01DRV9MT0cpCQkrPSBtY2Vsb2cubwog
b2JqLSQoQ09ORklHX1hFTl9QTEFURk9STV9QQ0kpCQkrPSB4ZW4tcGxhdGZvcm0tcGNpLm8KIG9i
ai0kKENPTkZJR19YRU5fVE1FTSkJCQkrPSB0bWVtLm8KIG9iai0kKENPTkZJR19TV0lPVExCX1hF
TikJCSs9IHN3aW90bGIteGVuLm8KZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVuL21jZWxvZy5jIGIv
ZHJpdmVycy94ZW4vbWNlbG9nLmMKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4u
ODkyY2E3YgotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZlcnMveGVuL21jZWxvZy5jCkBAIC0wLDAg
KzEsMjE3IEBACisvKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCisgKiBtY2Vsb2cuYworICogQWRkIE1h
Y2hpbmUgQ2hlY2sgZXZlbnQgTG9nZ2luZyBzdXBwb3J0IGluIERPTTAKKyAqCisgKiBEcml2ZXIg
Zm9yIHJlY2VpdmluZyBhbmQgbG9nZ2luZyBtYWNoaW5lIGNoZWNrIGV2ZW50CisgKgorICogQ29w
eXJpZ2h0IChjKSAyMDA4LCAyMDA5IEludGVsIENvcnBvcmF0aW9uCisgKgorICogVGhpcyBwcm9n
cmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vcgorICog
bW9kaWZ5IGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vu
c2UgdmVyc2lvbiAyCisgKiBhcyBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRh
dGlvbjsgb3IsIHdoZW4gZGlzdHJpYnV0ZWQKKyAqIHNlcGFyYXRlbHkgZnJvbSB0aGUgTGludXgg
a2VybmVsIG9yIGluY29ycG9yYXRlZCBpbnRvIG90aGVyCisgKiBzb2Z0d2FyZSBwYWNrYWdlcywg
c3ViamVjdCB0byB0aGUgZm9sbG93aW5nIGxpY2Vuc2U6CisgKgorICogUGVybWlzc2lvbiBpcyBo
ZXJlYnkgZ3JhbnRlZCwgZnJlZSBvZiBjaGFyZ2UsIHRvIGFueSBwZXJzb24gb2J0YWluaW5nIGEg
Y29weQorICogb2YgdGhpcyBzb3VyY2UgZmlsZSAodGhlICJTb2Z0d2FyZSIpLCB0byBkZWFsIGlu
IHRoZSBTb2Z0d2FyZSB3aXRob3V0CisgKiByZXN0cmljdGlvbiwgaW5jbHVkaW5nIHdpdGhvdXQg
bGltaXRhdGlvbiB0aGUgcmlnaHRzIHRvIHVzZSwgY29weSwgbW9kaWZ5LAorICogbWVyZ2UsIHB1
Ymxpc2gsIGRpc3RyaWJ1dGUsIHN1YmxpY2Vuc2UsIGFuZC9vciBzZWxsIGNvcGllcyBvZiB0aGUg
U29mdHdhcmUsCisgKiBhbmQgdG8gcGVybWl0IHBlcnNvbnMgdG8gd2hvbSB0aGUgU29mdHdhcmUg
aXMgZnVybmlzaGVkIHRvIGRvIHNvLCBzdWJqZWN0IHRvCisgKiB0aGUgZm9sbG93aW5nIGNvbmRp
dGlvbnM6CisgKgorICogVGhlIGFib3ZlIGNvcHlyaWdodCBub3RpY2UgYW5kIHRoaXMgcGVybWlz
c2lvbiBub3RpY2Ugc2hhbGwgYmUgaW5jbHVkZWQgaW4KKyAqIGFsbCBjb3BpZXMgb3Igc3Vic3Rh
bnRpYWwgcG9ydGlvbnMgb2YgdGhlIFNvZnR3YXJlLgorICoKKyAqIFRIRSBTT0ZUV0FSRSBJUyBQ
Uk9WSURFRCAiQVMgSVMiLCBXSVRIT1VUIFdBUlJBTlRZIE9GIEFOWSBLSU5ELCBFWFBSRVNTIE9S
CisgKiBJTVBMSUVELCBJTkNMVURJTkcgQlVUIE5PVCBMSU1JVEVEIFRPIFRIRSBXQVJSQU5USUVT
IE9GIE1FUkNIQU5UQUJJTElUWSwKKyAqIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NF
IEFORCBOT05JTkZSSU5HRU1FTlQuIElOIE5PIEVWRU5UIFNIQUxMIFRIRQorICogQVVUSE9SUyBP
UiBDT1BZUklHSFQgSE9MREVSUyBCRSBMSUFCTEUgRk9SIEFOWSBDTEFJTSwgREFNQUdFUyBPUiBP
VEhFUgorICogTElBQklMSVRZLCBXSEVUSEVSIElOIEFOIEFDVElPTiBPRiBDT05UUkFDVCwgVE9S
VCBPUiBPVEhFUldJU0UsIEFSSVNJTkcKKyAqIEZST00sIE9VVCBPRiBPUiBJTiBDT05ORUNUSU9O
IFdJVEggVEhFIFNPRlRXQVJFIE9SIFRIRSBVU0UgT1IgT1RIRVIgREVBTElOR1MKKyAqIElOIFRI
RSBTT0ZUV0FSRS4KKyAqLworCisjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+CisjaW5jbHVkZSA8
bGludXgvaW5pdC5oPgorI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+CisjaW5jbHVkZSA8bGludXgv
a2VybmVsLmg+CisjaW5jbHVkZSA8bGludXgvc2xhYi5oPgorI2luY2x1ZGUgPHhlbi9pbnRlcmZh
Y2UveGVuLmg+CisjaW5jbHVkZSA8YXNtL3hlbi9oeXBlcnZpc29yLmg+CisjaW5jbHVkZSA8eGVu
L2V2ZW50cy5oPgorI2luY2x1ZGUgPHhlbi9pbnRlcmZhY2UvdmNwdS5oPgorI2luY2x1ZGUgPGFz
bS94ZW4vaHlwZXJjYWxsLmg+CisjaW5jbHVkZSA8YXNtL21jZS5oPgorI2luY2x1ZGUgPHhlbi94
ZW4uaD4KKworc3RhdGljIG1jX2luZm9fdCAqZ19taTsKK3N0YXRpYyBtY2luZm9fbG9naWNhbF9j
cHVfdCAqZ19waHlzaW5mbzsKK3N0YXRpYyB1aW50MzJfdCBuY3B1czsKKworc3RhdGljIGludCBj
b252ZXJ0X2xvZyhzdHJ1Y3QgbWNfaW5mbyAqbWkpCit7CisJc3RydWN0IG1jaW5mb19jb21tb24g
Km1pYyA9IE5VTEw7CisJc3RydWN0IG1jaW5mb19nbG9iYWwgKm1jX2dsb2JhbDsKKwlzdHJ1Y3Qg
bWNpbmZvX2JhbmsgKm1jX2Jhbms7CisJc3RydWN0IG1jZSBtOworCWludCBpLCBmb3VuZCA9IDA7
CisKKwl4ODZfbWNpbmZvX2xvb2t1cCgmbWljLCBtaSwgTUNfVFlQRV9HTE9CQUwpOworCVdBUk5f
T04oIW1pYyk7CisKKwltY2Vfc2V0dXAoJm0pOworCW1jX2dsb2JhbCA9IChzdHJ1Y3QgbWNpbmZv
X2dsb2JhbCAqKW1pYzsKKwltLm1jZ3N0YXR1cyA9IG1jX2dsb2JhbC0+bWNfZ3N0YXR1czsKKwlt
LmFwaWNpZCA9IG1jX2dsb2JhbC0+bWNfYXBpY2lkOworCWZvciAoaSA9IDA7IGkgPCBuY3B1czsg
aSsrKSB7CisJCWlmIChnX3BoeXNpbmZvW2ldLm1jX2FwaWNpZCA9PSBtLmFwaWNpZCkgeworCQkJ
Zm91bmQgPSAxOworCQkJYnJlYWs7CisJCX0KKwl9CisJV0FSTl9PTighZm91bmQpOworCisJbS5z
b2NrZXRpZCA9IGdfcGh5c2luZm9baV0ubWNfY2hpcGlkOworCW0uY3B1ID0gbS5leHRjcHUgPSBn
X3BoeXNpbmZvW2ldLm1jX2NwdW5yOworCW0uY3B1dmVuZG9yID0gKF9fdTgpZ19waHlzaW5mb1tp
XS5tY192ZW5kb3I7CisJbS5tY2djYXAgPSBnX3BoeXNpbmZvW2ldLm1jX21zcnZhbHVlc1swXS52
YWx1ZTsKKwl4ODZfbWNpbmZvX2xvb2t1cCgmbWljLCBtaSwgTUNfVFlQRV9CQU5LKTsKKwlkbyB7
CisJCWlmIChtaWMgPT0gTlVMTCB8fCBtaWMtPnNpemUgPT0gMCkKKwkJCWJyZWFrOworCQlpZiAo
bWljLT50eXBlID09IE1DX1RZUEVfQkFOSykgeworCQkJbWNfYmFuayA9IChzdHJ1Y3QgbWNpbmZv
X2JhbmsgKiltaWM7CisJCQltLm1pc2MgPSBtY19iYW5rLT5tY19taXNjOworCQkJbS5zdGF0dXMg
PSBtY19iYW5rLT5tY19zdGF0dXM7CisJCQltLmFkZHIgPSBtY19iYW5rLT5tY19hZGRyOworCQkJ
bS50c2MgPSBtY19iYW5rLT5tY190c2M7CisJCQltLmJhbmsgPSBtY19iYW5rLT5tY19iYW5rOwor
CQkJbS5maW5pc2hlZCA9IDE7CisJCQkvKmxvZyB0aGlzIHJlY29yZCovCisJCQltY2VfbG9nKCZt
KTsKKwkJfQorCQltaWMgPSB4ODZfbWNpbmZvX25leHQobWljKTsKKwl9IHdoaWxlICgxKTsKKwor
CXJldHVybiAwOworfQorCisvKnB2X29wcyBkb21haW4gbWNlIHZpcnEgaGFuZGxlciwgbG9nZ2lu
ZyBwaHlzaWNhbCBtY2UgZXJyb3IgaW5mbyovCitzdGF0aWMgaXJxcmV0dXJuX3QgbWNlX2RvbV9p
bnRlcnJ1cHQoaW50IGlycSwgdm9pZCAqZGV2X2lkKQoreworCXhlbl9tY190IG1jX29wOworCWlu
dCByZXN1bHQgPSAwOworCisJbWNfb3AuY21kID0gWEVOX01DX2ZldGNoOworCW1jX29wLmludGVy
ZmFjZV92ZXJzaW9uID0gWEVOX01DQV9JTlRFUkZBQ0VfVkVSU0lPTjsKKwlzZXRfeGVuX2d1ZXN0
X2hhbmRsZShtY19vcC51Lm1jX2ZldGNoLmRhdGEsIGdfbWkpOwordXJnZW50OgorCW1jX29wLnUu
bWNfZmV0Y2guZmxhZ3MgPSBYRU5fTUNfVVJHRU5UOworCXJlc3VsdCA9IEhZUEVSVklTT1JfbWNh
KCZtY19vcCk7CisJaWYgKHJlc3VsdCB8fCBtY19vcC51Lm1jX2ZldGNoLmZsYWdzICYgWEVOX01D
X05PREFUQSB8fAorCQkJbWNfb3AudS5tY19mZXRjaC5mbGFncyAmIFhFTl9NQ19GRVRDSEZBSUxF
RCkKKwkJZ290byBub251cmdlbnQ7CisJZWxzZSB7CisJCXJlc3VsdCA9IGNvbnZlcnRfbG9nKGdf
bWkpOworCQlpZiAocmVzdWx0KQorCQkJZ290byBlbmQ7CisJCS8qIEFmdGVyIGZldGNoaW5nIHRo
ZSBlcnJvciBldmVudCBsb2cgZW50cnkgZnJvbSBET00wLAorCQkgKiB3ZSBuZWVkIHRvIGRlYyB0
aGUgcmVmY250IGFuZCByZWxlYXNlIHRoZSBlbnRyeS4KKwkJICogVGhlIGVudHJ5IGlzIHJlc2Vy
dmVkIGFuZCBpbmMgcmVmY250IHdoZW4gZmlsbGluZworCQkgKiB0aGUgZXJyb3IgbG9nIGVudHJ5
LgorCQkgKi8KKwkJbWNfb3AudS5tY19mZXRjaC5mbGFncyA9IFhFTl9NQ19VUkdFTlQgfCBYRU5f
TUNfQUNLOworCQlyZXN1bHQgPSBIWVBFUlZJU09SX21jYSgmbWNfb3ApOworCQlnb3RvIHVyZ2Vu
dDsKKwl9Citub251cmdlbnQ6CisJbWNfb3AudS5tY19mZXRjaC5mbGFncyA9IFhFTl9NQ19OT05V
UkdFTlQ7CisJcmVzdWx0ID0gSFlQRVJWSVNPUl9tY2EoJm1jX29wKTsKKwlpZiAocmVzdWx0IHx8
IG1jX29wLnUubWNfZmV0Y2guZmxhZ3MgJiBYRU5fTUNfTk9EQVRBIHx8CisJCQltY19vcC51Lm1j
X2ZldGNoLmZsYWdzICYgWEVOX01DX0ZFVENIRkFJTEVEKQorCQlnb3RvIGVuZDsKKwllbHNlIHsK
KwkJcmVzdWx0ID0gY29udmVydF9sb2coZ19taSk7CisJCWlmIChyZXN1bHQpCisJCQlnb3RvIGVu
ZDsKKwkJLyogQWZ0ZXIgZmV0Y2hpbmcgdGhlIGVycm9yIGV2ZW50IGxvZyBlbnRyeSBmcm9tIERP
TTAsCisJCSAqIHdlIG5lZWQgdG8gZGVjIHRoZSByZWZjbnQgYW5kIHJlbGVhc2UgdGhlIGVudHJ5
LiBUaGUKKwkJICogZW50cnkgaXMgcmVzZXJ2ZWQgYW5kIGluYyByZWZjbnQgd2hlbiBmaWxsaW5n
IHRoZQorCQkgKiBlcnJvciBsb2cgZW50cnkuCisJCSAqLworCQltY19vcC51Lm1jX2ZldGNoLmZs
YWdzID0gWEVOX01DX05PTlVSR0VOVCB8IFhFTl9NQ19BQ0s7CisJCXJlc3VsdCA9IEhZUEVSVklT
T1JfbWNhKCZtY19vcCk7CisJCWdvdG8gbm9udXJnZW50OworCX0KK2VuZDoKKwlyZXR1cm4gSVJR
X0hBTkRMRUQ7Cit9CisKK3N0YXRpYyBpbnQgYmluZF92aXJxX2Zvcl9tY2Uodm9pZCkKK3sKKwlp
bnQgcmV0OworCXhlbl9tY190IG1jX29wOworCisJZ19taSA9IGttYWxsb2Moc2l6ZW9mKHN0cnVj
dCBtY19pbmZvKSwgR0ZQX0tFUk5FTCk7CisKKwlpZiAoIWdfbWkpCisJCXJldHVybiAtRU5PTUVN
OworCisJLyogRmV0Y2ggcGh5c2ljYWwgQ1BVIE51bWJlcnMgKi8KKwltY19vcC5jbWQgPSBYRU5f
TUNfcGh5c2NwdWluZm87CisJbWNfb3AuaW50ZXJmYWNlX3ZlcnNpb24gPSBYRU5fTUNBX0lOVEVS
RkFDRV9WRVJTSU9OOworCXNldF94ZW5fZ3Vlc3RfaGFuZGxlKG1jX29wLnUubWNfcGh5c2NwdWlu
Zm8uaW5mbywgZ19waHlzaW5mbyk7CisJcmV0ID0gSFlQRVJWSVNPUl9tY2EoJm1jX29wKTsKKwlp
ZiAocmV0KSB7CisJCXByaW50ayhLRVJOX0VSUiAiTUNFX0RPTTBfTE9HOiBGYWlsIHRvIGdldCBw
aHlzaWNhbCBDUFUgbnVtYmVyc1xuIik7CisJCWtmcmVlKGdfbWkpOworCQlyZXR1cm4gcmV0Owor
CX0KKworCS8qIEZldGNoIGVhY2ggQ1BVIFBoeXNpY2FsIEluZm8gZm9yIGxhdGVyIHJlZmVyZW5j
ZSovCisJbmNwdXMgPSBtY19vcC51Lm1jX3BoeXNjcHVpbmZvLm5jcHVzOworCWdfcGh5c2luZm8g
PSBrbWFsbG9jKHNpemVvZihzdHJ1Y3QgbWNpbmZvX2xvZ2ljYWxfY3B1KSpuY3B1cywKKwkJCQkJ
R0ZQX0tFUk5FTCk7CisJaWYgKCFnX3BoeXNpbmZvKSB7CisJCWtmcmVlKGdfbWkpOworCQlyZXR1
cm4gLUVOT01FTTsKKwl9CisJc2V0X3hlbl9ndWVzdF9oYW5kbGUobWNfb3AudS5tY19waHlzY3B1
aW5mby5pbmZvLCBnX3BoeXNpbmZvKTsKKwlyZXQgPSBIWVBFUlZJU09SX21jYSgmbWNfb3ApOwor
CWlmIChyZXQpIHsKKwkJcHJpbnRrKEtFUk5fRVJSICJNQ0VfRE9NMF9MT0c6IEZhaWwgdG8gZ2V0
IHBoeXNpY2FsIENQVXMgaW5mb1xuIik7CisJCWtmcmVlKGdfbWkpOworCQlrZnJlZShnX3BoeXNp
bmZvKTsKKwkJcmV0dXJuIHJldDsKKwl9CisKKwlyZXQgID0gYmluZF92aXJxX3RvX2lycWhhbmRs
ZXIoVklSUV9NQ0EsIDAsCisJCW1jZV9kb21faW50ZXJydXB0LCAwLCAibWNlIiwgTlVMTCk7CisK
KwlpZiAocmV0IDwgMCkgeworCQlwcmludGsoS0VSTl9FUlIgIk1DRV9ET00wX0xPRzogYmluZF92
aXJxIGZvciBET00wIGZhaWxlZFxuIik7CisJCXJldHVybiByZXQ7CisJfQorCisJcmV0dXJuIDA7
Cit9CisKK3N0YXRpYyBpbnQgX19pbml0IG1jZWxvZ19pbml0KHZvaWQpCit7CisJLyogT25seSBE
T00wIGlzIHJlc3BvbnNpYmxlIGZvciBNQ0UgbG9nZ2luZyAqLworCWlmICh4ZW5faW5pdGlhbF9k
b21haW4oKSkKKwkJcmV0dXJuIGJpbmRfdmlycV9mb3JfbWNlKCk7CisKKwlyZXR1cm4gMDsKK30K
KworCitzdGF0aWMgdm9pZCBfX2V4aXQgbWNlbG9nX2NsZWFudXAodm9pZCkKK3sKKwlrZnJlZShn
X21pKTsKKwlrZnJlZShnX3BoeXNpbmZvKTsKK30KK21vZHVsZV9pbml0KG1jZWxvZ19pbml0KTsK
K21vZHVsZV9leGl0KG1jZWxvZ19jbGVhbnVwKTsKKworTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOwpk
aWZmIC0tZ2l0IGEvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3hlbi1tY2EuaCBiL2luY2x1ZGUveGVu
L2ludGVyZmFjZS94ZW4tbWNhLmgKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4u
ZjMxZmRhYgotLS0gL2Rldi9udWxsCisrKyBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS94ZW4tbWNh
LmgKQEAgLTAsMCArMSw0MjkgQEAKKy8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKKyAqIGFyY2gteDg2
L21jYS5oCisgKgorICogQ29udHJpYnV0ZWQgYnkgQWR2YW5jZWQgTWljcm8gRGV2aWNlcywgSW5j
LgorICogQXV0aG9yOiBDaHJpc3RvcGggRWdnZXIgPENocmlzdG9waC5FZ2dlckBhbWQuY29tPgor
ICoKKyAqIEd1ZXN0IE9TIG1hY2hpbmUgY2hlY2sgaW50ZXJmYWNlIHRvIHg4NiBYZW4uCisgKgor
ICogUGVybWlzc2lvbiBpcyBoZXJlYnkgZ3JhbnRlZCwgZnJlZSBvZiBjaGFyZ2UsIHRvIGFueSBw
ZXJzb24gb2J0YWluaW5nIGEgY29weQorICogb2YgdGhpcyBzb2Z0d2FyZSBhbmQgYXNzb2NpYXRl
ZCBkb2N1bWVudGF0aW9uIGZpbGVzICh0aGUgIlNvZnR3YXJlIiksIHRvCisgKiBkZWFsIGluIHRo
ZSBTb2Z0d2FyZSB3aXRob3V0IHJlc3RyaWN0aW9uLCBpbmNsdWRpbmcgd2l0aG91dCBsaW1pdGF0
aW9uIHRoZQorICogcmlnaHRzIHRvIHVzZSwgY29weSwgbW9kaWZ5LCBtZXJnZSwgcHVibGlzaCwg
ZGlzdHJpYnV0ZSwgc3VibGljZW5zZSwgYW5kL29yCisgKiBzZWxsIGNvcGllcyBvZiB0aGUgU29m
dHdhcmUsIGFuZCB0byBwZXJtaXQgcGVyc29ucyB0byB3aG9tIHRoZSBTb2Z0d2FyZSBpcworICog
ZnVybmlzaGVkIHRvIGRvIHNvLCBzdWJqZWN0IHRvIHRoZSBmb2xsb3dpbmcgY29uZGl0aW9uczoK
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
SEUgU09GVFdBUkUgT1IgVEhFIFVTRSBPUiBPVEhFUgorICogREVBTElOR1MgSU4gVEhFIFNPRlRX
QVJFLgorICovCisKKy8qIEZ1bGwgTUNBIGZ1bmN0aW9uYWxpdHkgaGFzIHRoZSBmb2xsb3dpbmcg
VXNlY2FzZXMgZnJvbSB0aGUgZ3Vlc3Qgc2lkZToKKyAqCisgKiBNdXN0IGhhdmUnczoKKyAqIDEu
IERvbTAgYW5kIERvbVUgcmVnaXN0ZXIgbWFjaGluZSBjaGVjayB0cmFwIGNhbGxiYWNrIGhhbmRs
ZXJzCisgKiAgICAoYWxyZWFkeSBkb25lIHZpYSAic2V0X3RyYXBfdGFibGUiIGh5cGVyY2FsbCkK
KyAqIDIuIERvbTAgcmVnaXN0ZXJzIG1hY2hpbmUgY2hlY2sgZXZlbnQgY2FsbGJhY2sgaGFuZGxl
cgorICogICAgKGRvYWJsZSB2aWEgRVZUQ0hOT1BfYmluZF92aXJxKQorICogMy4gRG9tMCBhbmQg
RG9tVSBmZXRjaGVzIG1hY2hpbmUgY2hlY2sgZGF0YQorICogNC4gRG9tMCB3YW50cyBYZW4gdG8g
bm90aWZ5IGEgRG9tVQorICogNS4gRG9tMCBnZXRzIERvbVUgSUQgZnJvbSBwaHlzaWNhbCBhZGRy
ZXNzCisgKiA2LiBEb20wIHdhbnRzIFhlbiB0byBraWxsIERvbVUgKGFscmVhZHkgZG9uZSBmb3Ig
InhtIGRlc3Ryb3kiKQorICoKKyAqIE5pY2UgdG8gaGF2ZSdzOgorICogNy4gRG9tMCB3YW50cyBY
ZW4gdG8gZGVhY3RpdmF0ZSBhIHBoeXNpY2FsIENQVQorICogICAgVGhpcyBpcyBiZXR0ZXIgZG9u
ZSBhcyBzZXBhcmF0ZSB0YXNrLCBwaHlzaWNhbCBDUFUgaG90cGx1Z2dpbmcsCisgKiAgICBhbmQg
aHlwZXJjYWxsKHMpIHNob3VsZCBiZSBzeXNjdGwncworICogOC4gUGFnZSBtaWdyYXRpb24gcHJv
cG9zZWQgZnJvbSBYZW4gTlVNQSB3b3JrLCB3aGVyZSBEb20wIGNhbiB0ZWxsIFhlbiB0bworICog
ICAgbW92ZSBhIERvbVUgKG9yIERvbTAgaXRzZWxmKSBhd2F5IGZyb20gYSBtYWxpY2lvdXMgcGFn
ZQorICogICAgcHJvZHVjaW5nIGNvcnJlY3RhYmxlIGVycm9ycy4KKyAqIDkuIG9mZmxpbmluZyBw
aHlzaWNhbCBwYWdlOgorICogICAgWGVuIGZyZWUncyBhbmQgbmV2ZXIgcmUtdXNlcyBhIGNlcnRh
aW4gcGh5c2ljYWwgcGFnZS4KKyAqIDEwLiBUZXN0ZmFjaWxpdHk6IEFsbG93IERvbTAgdG8gd3Jp
dGUgdmFsdWVzIGludG8gbWFjaGluZSBjaGVjayBNU1IncworICogICAgIGFuZCB0ZWxsIFhlbiB0
byB0cmlnZ2VyIGEgbWFjaGluZSBjaGVjaworICovCisKKyNpZm5kZWYgX19YRU5fUFVCTElDX0FS
Q0hfWDg2X01DQV9IX18KKyNkZWZpbmUgX19YRU5fUFVCTElDX0FSQ0hfWDg2X01DQV9IX18KKwor
LyogSHlwZXJjYWxsICovCisjZGVmaW5lIF9fSFlQRVJWSVNPUl9tY2EgX19IWVBFUlZJU09SX2Fy
Y2hfMAorCisvKgorICogVGhlIHhlbi11bnN0YWJsZSByZXBvIGhhcyBpbnRlcmZhY2UgdmVyc2lv
biAweDAzMDAwMDAxOyBvdXQgaW50ZXJmYWNlCisgKiBpcyBpbmNvbXBhdGlibGUgd2l0aCB0aGF0
IGFuZCBhbnkgZnV0dXJlIG1pbm9yIHJldmlzaW9ucywgc28gd2UKKyAqIGNob29zZSBhIGRpZmZl
cmVudCB2ZXJzaW9uIG51bWJlciByYW5nZSB0aGF0IGlzIG51bWVyaWNhbGx5IGxlc3MKKyAqIHRo
YW4gdGhhdCB1c2VkIGluIHhlbi11bnN0YWJsZS4KKyAqLworI2RlZmluZSBYRU5fTUNBX0lOVEVS
RkFDRV9WRVJTSU9OIDB4MDFlY2MwMDMKKworLyogSU46IERvbTAgY2FsbHMgaHlwZXJjYWxsIHRv
IHJldHJpZXZlIG5vbnVyZ2VudCBlcnJvciBsb2cgZW50cnkgKi8KKyNkZWZpbmUgWEVOX01DX05P
TlVSR0VOVCAgMHgwMDAxCisvKiBJTjogRG9tMC9Eb21VIGNhbGxzIGh5cGVyY2FsbCB0byByZXRy
aWV2ZSB1cmdlbnQgZXJyb3IgbG9nIGVudHJ5ICovCisjZGVmaW5lIFhFTl9NQ19VUkdFTlQgICAg
IDB4MDAwMgorLyogSU46IERvbTAgYWNrbm93bGVkZ2VzIHByZXZpb3NseS1mZXRjaGVkIGVycm9y
IGxvZyBlbnRyeSAqLworI2RlZmluZSBYRU5fTUNfQUNLICAgICAgICAweDAwMDQKKworLyogT1VU
OiBBbGwgaXMgb2sgKi8KKyNkZWZpbmUgWEVOX01DX09LICAgICAgICAgICAweDAKKy8qIE9VVDog
RG9tYWluIGNvdWxkIG5vdCBmZXRjaCBkYXRhLiAqLworI2RlZmluZSBYRU5fTUNfRkVUQ0hGQUlM
RUQgIDB4MQorLyogT1VUOiBUaGVyZSB3YXMgbm8gbWFjaGluZSBjaGVjayBkYXRhIHRvIGZldGNo
LiAqLworI2RlZmluZSBYRU5fTUNfTk9EQVRBICAgICAgIDB4MgorLyogT1VUOiBCZXR3ZWVuIG5v
dGlmaWNhdGlvbiB0aW1lIGFuZCB0aGlzIGh5cGVyY2FsbCBhbiBvdGhlcgorICogIChtb3N0IGxp
a2VseSkgY29ycmVjdGFibGUgZXJyb3IgaGFwcGVuZWQuIFRoZSBmZXRjaGVkIGRhdGEsCisgKiAg
ZG9lcyBub3QgbWF0Y2ggdGhlIG9yaWdpbmFsIG1hY2hpbmUgY2hlY2sgZGF0YS4gKi8KKyNkZWZp
bmUgWEVOX01DX05PTUFUQ0ggICAgICAweDQKKworLyogT1VUOiBEb21VIGRpZCBub3QgcmVnaXN0
ZXIgTUMgTk1JIGhhbmRsZXIuIFRyeSBzb21ldGhpbmcgZWxzZS4gKi8KKyNkZWZpbmUgWEVOX01D
X0NBTk5PVEhBTkRMRSAweDgKKy8qIE9VVDogTm90aWZ5aW5nIERvbVUgZmFpbGVkLiBSZXRyeSBs
YXRlciBvciB0cnkgc29tZXRoaW5nIGVsc2UuICovCisjZGVmaW5lIFhFTl9NQ19OT1RERUxJVkVS
RUQgMHgxMAorLyogTm90ZSwgWEVOX01DX0NBTk5PVEhBTkRMRSBhbmQgWEVOX01DX05PVERFTElW
RVJFRCBhcmUgbXV0dWFsbHkgZXhjbHVzaXZlLiAqLworCisKKyNpZm5kZWYgX19BU1NFTUJMWV9f
CisKKyNkZWZpbmUgVklSUV9NQ0EgVklSUV9BUkNIXzAgLyogRy4gKERPTTApIE1hY2hpbmUgQ2hl
Y2sgQXJjaGl0ZWN0dXJlICovCisKKy8qCisgKiBNYWNoaW5lIENoZWNrIEFyY2hpdGVjdXJlOgor
ICogc3RydWN0cyBhcmUgcmVhZC1vbmx5IGFuZCB1c2VkIHRvIHJlcG9ydCBhbGwga2luZHMgb2YK
KyAqIGNvcnJlY3RhYmxlIGFuZCB1bmNvcnJlY3RhYmxlIGVycm9ycyBkZXRlY3RlZCBieSB0aGUg
SFcuCisgKiBEb20wIGFuZCBEb21VOiByZWdpc3RlciBhIGhhbmRsZXIgdG8gZ2V0IG5vdGlmaWVk
LgorICogRG9tMCBvbmx5OiBDb3JyZWN0YWJsZSBlcnJvcnMgYXJlIHJlcG9ydGVkIHZpYSBWSVJR
X01DQQorICovCisjZGVmaW5lIE1DX1RZUEVfR0xPQkFMICAgICAgICAgIDAKKyNkZWZpbmUgTUNf
VFlQRV9CQU5LICAgICAgICAgICAgMQorI2RlZmluZSBNQ19UWVBFX0VYVEVOREVEICAgICAgICAy
CisjZGVmaW5lIE1DX1RZUEVfUkVDT1ZFUlkgICAgICAgIDMKKworc3RydWN0IG1jaW5mb19jb21t
b24geworCXVpbnQxNl90IHR5cGU7ICAgICAgLyogc3RydWN0dXJlIHR5cGUgKi8KKwl1aW50MTZf
dCBzaXplOyAgICAgIC8qIHNpemUgb2YgdGhpcyBzdHJ1Y3QgaW4gYnl0ZXMgKi8KK307CisKKwor
I2RlZmluZSBNQ19GTEFHX0NPUlJFQ1RBQkxFICAgICAoMSA8PCAwKQorI2RlZmluZSBNQ19GTEFH
X1VOQ09SUkVDVEFCTEUgICAoMSA8PCAxKQorI2RlZmluZSBNQ19GTEFHX1JFQ09WRVJBQkxFCSgx
IDw8IDIpCisjZGVmaW5lIE1DX0ZMQUdfUE9MTEVECQkoMSA8PCAzKQorI2RlZmluZSBNQ19GTEFH
X1JFU0VUCQkoMSA8PCA0KQorI2RlZmluZSBNQ19GTEFHX0NNQ0kJCSgxIDw8IDUpCisjZGVmaW5l
IE1DX0ZMQUdfTUNFCQkoMSA8PCA2KQorLyogY29udGFpbnMgZ2xvYmFsIHg4NiBtYyBpbmZvcm1h
dGlvbiAqLworc3RydWN0IG1jaW5mb19nbG9iYWwgeworCXN0cnVjdCBtY2luZm9fY29tbW9uIGNv
bW1vbjsKKworCS8qIHJ1bm5pbmcgZG9tYWluIGF0IHRoZSB0aW1lIGluIGVycm9yIChtb3N0IGxp
a2VseQorCSAqIHRoZSBpbXBhY3RlZCBvbmUpICovCisJdWludDE2X3QgbWNfZG9taWQ7CisJdWlu
dDE2X3QgbWNfdmNwdWlkOyAvKiB2aXJ0dWFsIGNwdSBzY2hlZHVsZWQgZm9yIG1jX2RvbWlkICov
CisJdWludDMyX3QgbWNfc29ja2V0aWQ7IC8qIHBoeXNpY2FsIHNvY2tldCBvZiB0aGUgcGh5c2lj
YWwgY29yZSAqLworCXVpbnQxNl90IG1jX2NvcmVpZDsgLyogcGh5c2ljYWwgaW1wYWN0ZWQgY29y
ZSAqLworCXVpbnQxNl90IG1jX2NvcmVfdGhyZWFkaWQ7IC8qIGNvcmUgdGhyZWFkIG9mIHBoeXNp
Y2FsIGNvcmUgKi8KKwl1aW50MzJfdCBtY19hcGljaWQ7CisJdWludDMyX3QgbWNfZmxhZ3M7CisJ
dWludDY0X3QgbWNfZ3N0YXR1czsgLyogZ2xvYmFsIHN0YXR1cyAqLworfTsKKworLyogY29udGFp
bnMgYmFuayBsb2NhbCB4ODYgbWMgaW5mb3JtYXRpb24gKi8KK3N0cnVjdCBtY2luZm9fYmFuayB7
CisJc3RydWN0IG1jaW5mb19jb21tb24gY29tbW9uOworCisJdWludDE2X3QgbWNfYmFuazsgLyog
YmFuayBuciAqLworCXVpbnQxNl90IG1jX2RvbWlkOyAvKiBVc2VjYXNlIDU6IGRvbWFpbiByZWZl
cmVuY2VkIGJ5IG1jX2FkZHIgb24KKwkJCSogcHJpdmlsZWdlZCBwdi1vcHMgZG9tIGFuZCBpZiBt
Y19hZGRyIGlzIHZhbGlkLgorCQkJKiBOZXZlciB2YWxpZCBvbiBEb21VLiAqLworCXVpbnQ2NF90
IG1jX3N0YXR1czsgLyogYmFuayBzdGF0dXMgKi8KKwl1aW50NjRfdCBtY19hZGRyOyAgIC8qIGJh
bmsgYWRkcmVzcywgb25seSB2YWxpZAorCQkJCQkgKiBpZiBhZGRyIGJpdCBpcyBzZXQgaW4gbWNf
c3RhdHVzICovCisJdWludDY0X3QgbWNfbWlzYzsKKwl1aW50NjRfdCBtY19jdHJsMjsKKwl1aW50
NjRfdCBtY190c2M7Cit9OworCisKK3N0cnVjdCBtY2luZm9fbXNyIHsKKwl1aW50NjRfdCByZWc7
ICAgLyogTVNSICovCisJdWludDY0X3QgdmFsdWU7IC8qIE1TUiB2YWx1ZSAqLworfTsKKworLyog
Y29udGFpbnMgbWMgaW5mb3JtYXRpb24gZnJvbSBvdGhlcgorICogb3IgYWRkaXRpb25hbCBtYyBN
U1JzICovCitzdHJ1Y3QgbWNpbmZvX2V4dGVuZGVkIHsKKwlzdHJ1Y3QgbWNpbmZvX2NvbW1vbiBj
b21tb247CisKKwkvKiBZb3UgY2FuIGZpbGwgdXAgdG8gZml2ZSByZWdpc3RlcnMuCisJICogSWYg
eW91IG5lZWQgbW9yZSwgdGhlbiB1c2UgdGhpcyBzdHJ1Y3R1cmUKKwkgKiBtdWx0aXBsZSB0aW1l
cy4gKi8KKworCXVpbnQzMl90IG1jX21zcnM7IC8qIE51bWJlciBvZiBtc3Igd2l0aCB2YWxpZCB2
YWx1ZXMuICovCisJLyoKKwkgKiBDdXJyZW50bHkgSW50ZWwgZXh0ZW5kZWQgTVNSICgzMi82NCkg
aW5jbHVkZSBhbGwgZ3AgcmVnaXN0ZXJzCisJICogYW5kIEUoUilGTEFHUywgRShSKUlQLCBFKFIp
TUlTQywgdXAgdG8gMTEvMTkgb2YgdGhlbSBtaWdodCBiZQorCSAqIHVzZWZ1bCBhdCBwcmVzZW50
LiBTbyBleHBhbmQgdGhpcyBhcnJheSB0byAxNi8zMiB0byBsZWF2ZSByb29tLgorCSAqLworCXN0
cnVjdCBtY2luZm9fbXNyIG1jX21zcltzaXplb2Yodm9pZCAqKSAqIDRdOworfTsKKworLyogUmVj
b3ZlcnkgQWN0aW9uIGZsYWdzLiBHaXZpbmcgcmVjb3ZlcnkgcmVzdWx0IGluZm9ybWF0aW9uIHRv
IERPTTAgKi8KKworLyogWGVuIHRha2VzIHN1Y2Nlc3NmdWwgcmVjb3ZlcnkgYWN0aW9uLCB0aGUg
ZXJyb3IgaXMgcmVjb3ZlcmVkICovCisjZGVmaW5lIFJFQ19BQ1RJT05fUkVDT1ZFUkVEICgweDEg
PDwgMCkKKy8qIE5vIGFjdGlvbiBpcyBwZXJmb3JtZWQgYnkgWEVOICovCisjZGVmaW5lIFJFQ19B
Q1RJT05fTk9ORSAoMHgxIDw8IDEpCisvKiBJdCdzIHBvc3NpYmxlIERPTTAgbWlnaHQgdGFrZSBh
Y3Rpb24gb3duZXJzaGlwIGluIHNvbWUgY2FzZSAqLworI2RlZmluZSBSRUNfQUNUSU9OX05FRURf
UkVTRVQgKDB4MSA8PCAyKQorCisvKiBEaWZmZXJlbnQgUmVjb3ZlcnkgQWN0aW9uIHR5cGVzLCBp
ZiB0aGUgYWN0aW9uIGlzIHBlcmZvcm1lZCBzdWNjZXNzZnVsbHksCisgKiBSRUNfQUNUSU9OX1JF
Q09WRVJFRCBmbGFnIHdpbGwgYmUgcmV0dXJuZWQuCisgKi8KKworLyogUGFnZSBPZmZsaW5lIEFj
dGlvbiAqLworI2RlZmluZSBNQ19BQ1RJT05fUEFHRV9PRkZMSU5FICgweDEgPDwgMCkKKy8qIENQ
VSBvZmZsaW5lIEFjdGlvbiAqLworI2RlZmluZSBNQ19BQ1RJT05fQ1BVX09GRkxJTkUgKDB4MSA8
PCAxKQorLyogTDMgY2FjaGUgZGlzYWJsZSBBY3Rpb24gKi8KKyNkZWZpbmUgTUNfQUNUSU9OX0NB
Q0hFX1NIUklOSyAoMHgxIDw8IDIpCisKKy8qIEJlbG93IGludGVyZmFjZSB1c2VkIGJldHdlZW4g
WEVOL0RPTTAgZm9yIHBhc3NpbmcgWEVOJ3MgcmVjb3ZlcnkgYWN0aW9uCisgKiBpbmZvcm1hdGlv
biB0byBET00wLgorICogdXNhZ2UgU2VuYXJpbzogQWZ0ZXIgb2ZmbGluaW5nIGJyb2tlbiBwYWdl
LCBYRU4gbWlnaHQgcGFzcyBpdHMgcGFnZSBvZmZsaW5lCisgKiByZWNvdmVyeSBhY3Rpb24gcmVz
dWx0IHRvIERPTTAuIERPTTAgd2lsbCBzYXZlIHRoZSBpbmZvcm1hdGlvbiBpbgorICogbm9uLXZv
bGF0aWxlIG1lbW9yeSBmb3IgZnVydGhlciBwcm9hY3RpdmUgYWN0aW9ucywgc3VjaCBhcyBvZmZs
aW5pbmcgdGhlCisgKiBlYXN5IGJyb2tlbiBwYWdlIGVhcmxpZXIgd2hlbiBkb2luZyBuZXh0IHJl
Ym9vdC4KKyovCitzdHJ1Y3QgcGFnZV9vZmZsaW5lX2FjdGlvbiB7CisJLyogUGFyYW1zIGZvciBw
YXNzaW5nIHRoZSBvZmZsaW5lZCBwYWdlIG51bWJlciB0byBET00wICovCisJdWludDY0X3QgbWZu
OworCXVpbnQ2NF90IHN0YXR1czsKK307CisKK3N0cnVjdCBjcHVfb2ZmbGluZV9hY3Rpb24gewor
CS8qIFBhcmFtcyBmb3IgcGFzc2luZyB0aGUgaWRlbnRpdHkgb2YgdGhlIG9mZmxpbmVkIENQVSB0
byBET00wICovCisJdWludDMyX3QgbWNfc29ja2V0aWQ7CisJdWludDE2X3QgbWNfY29yZWlkOwor
CXVpbnQxNl90IG1jX2NvcmVfdGhyZWFkaWQ7Cit9OworCisjZGVmaW5lIE1BWF9VTklPTl9TSVpF
IDE2CitzdHJ1Y3QgbWNpbmZvX3JlY292ZXJ5IHsKKwlzdHJ1Y3QgbWNpbmZvX2NvbW1vbiBjb21t
b247CisJdWludDE2X3QgbWNfYmFuazsgLyogYmFuayBuciAqLworCS8qIFJlY292ZXJ5IEFjdGlv
biBGbGFncyBkZWZpbmVkIGFib3ZlIHN1Y2ggYXMgUkVDX0FDVElPTl9ET05FICovCisJdWludDhf
dCBhY3Rpb25fZmxhZ3M7CisJLyogUmVjb3ZlcnkgQWN0aW9uIHR5cGVzIGRlZmluZWQgYWJvdmUg
c3VjaCBhcyBNQ19BQ1RJT05fUEFHRV9PRkZMSU5FICovCisJdWludDhfdCBhY3Rpb25fdHlwZXM7
CisJLyogSW4gZnV0dXJlIGlmIG1vcmUgdGhhbiBvbmUgcmVjb3ZlcnkgYWN0aW9uIHBlcm1pdHRl
ZCBwZXIgZXJyb3IgYmFuaywKKwkgKiBhIG1jaW5mb19yZWNvdmVyeSBkYXRhIGFycmF5IHdpbGwg
YmUgcmV0dXJuZWQKKwkgKi8KKwl1bmlvbiB7CisJCXN0cnVjdCBwYWdlX29mZmxpbmVfYWN0aW9u
IHBhZ2VfcmV0aXJlOworCQlzdHJ1Y3QgY3B1X29mZmxpbmVfYWN0aW9uIGNwdV9vZmZsaW5lOwor
CQl1aW50OF90IHBhZFtNQVhfVU5JT05fU0laRV07CisJfSBhY3Rpb25faW5mbzsKK307CisKKwor
I2RlZmluZSBNQ0lORk9fSFlQRVJDQUxMU0laRQkxMDI0CisjZGVmaW5lIE1DSU5GT19NQVhTSVpF
CQk3NjgKKworc3RydWN0IG1jX2luZm8geworCS8qIE51bWJlciBvZiBtY2luZm9fKiBlbnRyaWVz
IGluIG1pX2RhdGEgKi8KKwl1aW50MzJfdCBtaV9uZW50cmllczsKKwl1aW50MzJfdCBfcGFkMDsK
Kwl1aW50NjRfdCBtaV9kYXRhWyhNQ0lORk9fTUFYU0laRSAtIDEpIC8gOF07Cit9OwordHlwZWRl
ZiBzdHJ1Y3QgbWNfaW5mbyBtY19pbmZvX3Q7CitERUZJTkVfR1VFU1RfSEFORExFX1NUUlVDVCht
Y19pbmZvKTsKKworI2RlZmluZSBfX01DX01TUl9BUlJBWVNJWkUgOAorI2RlZmluZSBfX01DX05N
U1JTIDEKKyNkZWZpbmUgTUNfTkNBUFMJNwkvKiA3IENQVSBmZWF0dXJlIGZsYWcgd29yZHMgKi8K
KyNkZWZpbmUgTUNfQ0FQU19TVERfRURYCTAJLyogY3B1aWQgbGV2ZWwgMHgwMDAwMDAwMSAoJWVk
eCkgKi8KKyNkZWZpbmUgTUNfQ0FQU19BTURfRURYCTEJLyogY3B1aWQgbGV2ZWwgMHg4MDAwMDAw
MSAoJWVkeCkgKi8KKyNkZWZpbmUgTUNfQ0FQU19UTQkyCS8qIGNwdWlkIGxldmVsIDB4ODA4NjAw
MDEgKFRyYW5zTWV0YSkgKi8KKyNkZWZpbmUgTUNfQ0FQU19MSU5VWAkzCS8qIExpbnV4LWRlZmlu
ZWQgKi8KKyNkZWZpbmUgTUNfQ0FQU19TVERfRUNYCTQJLyogY3B1aWQgbGV2ZWwgMHgwMDAwMDAw
MSAoJWVjeCkgKi8KKyNkZWZpbmUgTUNfQ0FQU19WSUEJNQkvKiBjcHVpZCBsZXZlbCAweGMwMDAw
MDAxICovCisjZGVmaW5lIE1DX0NBUFNfQU1EX0VDWAk2CS8qIGNwdWlkIGxldmVsIDB4ODAwMDAw
MDEgKCVlY3gpICovCisKK3N0cnVjdCBtY2luZm9fbG9naWNhbF9jcHUgeworCXVpbnQzMl90IG1j
X2NwdW5yOworCXVpbnQzMl90IG1jX2NoaXBpZDsKKwl1aW50MTZfdCBtY19jb3JlaWQ7CisJdWlu
dDE2X3QgbWNfdGhyZWFkaWQ7CisJdWludDMyX3QgbWNfYXBpY2lkOworCXVpbnQzMl90IG1jX2Ns
dXN0ZXJpZDsKKwl1aW50MzJfdCBtY19uY29yZXM7CisJdWludDMyX3QgbWNfbmNvcmVzX2FjdGl2
ZTsKKwl1aW50MzJfdCBtY19udGhyZWFkczsKKwlpbnQzMl90IG1jX2NwdWlkX2xldmVsOworCXVp
bnQzMl90IG1jX2ZhbWlseTsKKwl1aW50MzJfdCBtY192ZW5kb3I7CisJdWludDMyX3QgbWNfbW9k
ZWw7CisJdWludDMyX3QgbWNfc3RlcDsKKwljaGFyIG1jX3ZlbmRvcmlkWzE2XTsKKwljaGFyIG1j
X2JyYW5kaWRbNjRdOworCXVpbnQzMl90IG1jX2NwdV9jYXBzW01DX05DQVBTXTsKKwl1aW50MzJf
dCBtY19jYWNoZV9zaXplOworCXVpbnQzMl90IG1jX2NhY2hlX2FsaWdubWVudDsKKwlpbnQzMl90
IG1jX25tc3J2YWxzOworCXN0cnVjdCBtY2luZm9fbXNyIG1jX21zcnZhbHVlc1tfX01DX01TUl9B
UlJBWVNJWkVdOworfTsKK3R5cGVkZWYgc3RydWN0IG1jaW5mb19sb2dpY2FsX2NwdSBtY2luZm9f
bG9naWNhbF9jcHVfdDsKK0RFRklORV9HVUVTVF9IQU5ETEVfU1RSVUNUKG1jaW5mb19sb2dpY2Fs
X2NwdSk7CisKKworLyoKKyAqIE9TJ3Mgc2hvdWxkIHVzZSB0aGVzZSBpbnN0ZWFkIG9mIHdyaXRp
bmcgdGhlaXIgb3duIGxvb2t1cCBmdW5jdGlvbgorICogZWFjaCB3aXRoIGl0cyBvd24gYnVncyBh
bmQgZHJhd2JhY2tzLgorICogV2UgdXNlIG1hY3JvcyBpbnN0ZWFkIG9mIHN0YXRpYyBpbmxpbmUg
ZnVuY3Rpb25zIHRvIGFsbG93IGd1ZXN0cworICogdG8gaW5jbHVkZSB0aGlzIGhlYWRlciBpbiBh
c3NlbWJseSBmaWxlcyAoKi5TKS4KKyAqLworLyogUHJvdG90eXBlOgorICogICAgdWludDMyX3Qg
eDg2X21jaW5mb19uZW50cmllcyhzdHJ1Y3QgbWNfaW5mbyAqbWkpOworICovCisjZGVmaW5lIHg4
Nl9tY2luZm9fbmVudHJpZXMoX21pKSAgICBcCisgICAgKChfbWkpLT5taV9uZW50cmllcykKKy8q
IFByb3RvdHlwZToKKyAqICAgIHN0cnVjdCBtY2luZm9fY29tbW9uICp4ODZfbWNpbmZvX2ZpcnN0
KHN0cnVjdCBtY19pbmZvICptaSk7CisgKi8KKyNkZWZpbmUgeDg2X21jaW5mb19maXJzdChfbWkp
ICAgICAgIFwKKyAgICAoKHN0cnVjdCBtY2luZm9fY29tbW9uICopKF9taSktPm1pX2RhdGEpCisv
KiBQcm90b3R5cGU6CisgKiAgICBzdHJ1Y3QgbWNpbmZvX2NvbW1vbiAqeDg2X21jaW5mb19uZXh0
KHN0cnVjdCBtY2luZm9fY29tbW9uICptaWMpOworICovCisjZGVmaW5lIHg4Nl9tY2luZm9fbmV4
dChfbWljKSAgICAgICBcCisgICAgKChzdHJ1Y3QgbWNpbmZvX2NvbW1vbiAqKSgodWludDhfdCAq
KShfbWljKSArIChfbWljKS0+c2l6ZSkpCisKKy8qIFByb3RvdHlwZToKKyAqICAgIHZvaWQgeDg2
X21jaW5mb19sb29rdXAodm9pZCAqcmV0LCBzdHJ1Y3QgbWNfaW5mbyAqbWksIHVpbnQxNl90IHR5
cGUpOworICovCisKK3N0YXRpYyBpbmxpbmUgdm9pZCB4ODZfbWNpbmZvX2xvb2t1cAorCShzdHJ1
Y3QgbWNpbmZvX2NvbW1vbiAqKnJldCwgc3RydWN0IG1jX2luZm8gKm1pLCB1aW50MTZfdCB0eXBl
KQoreworCXVpbnQzMl90IGZvdW5kID0gMCwgaTsKKwlzdHJ1Y3QgbWNpbmZvX2NvbW1vbiAqbWlj
OworCisJKnJldCA9IE5VTEw7CisJaWYgKCFtaSkKKwkJcmV0dXJuOworCW1pYyA9IHg4Nl9tY2lu
Zm9fZmlyc3QobWkpOworCisJZm9yIChpID0gMDsgaSA8IHg4Nl9tY2luZm9fbmVudHJpZXMobWkp
OyBpKyspIHsKKwkJaWYgKG1pYy0+dHlwZSA9PSB0eXBlKSB7CisJCQlmb3VuZCA9IDE7CisJCQli
cmVhazsKKwkJfQorCQltaWMgPSB4ODZfbWNpbmZvX25leHQobWljKTsKKwl9CisKKwkqcmV0ID0g
Zm91bmQgPyBtaWMgOiBOVUxMOworfQorLyogVXNlY2FzZSAxCisgKiBSZWdpc3RlciBtYWNoaW5l
IGNoZWNrIHRyYXAgY2FsbGJhY2sgaGFuZGxlcgorICogICAgKGFscmVhZHkgZG9uZSB2aWEgInNl
dF90cmFwX3RhYmxlIiBoeXBlcmNhbGwpCisgKi8KKworLyogVXNlY2FzZSAyCisgKiBEb20wIHJl
Z2lzdGVycyBtYWNoaW5lIGNoZWNrIGV2ZW50IGNhbGxiYWNrIGhhbmRsZXIKKyAqIGRvbmUgYnkg
RVZUQ0hOT1BfYmluZF92aXJxCisgKi8KKworLyogVXNlY2FzZSAzCisgKiBGZXRjaCBtYWNoaW5l
IGNoZWNrIGRhdGEgZnJvbSBoeXBlcnZpc29yLgorICogTm90ZSwgdGhpcyBoeXBlcmNhbGwgaXMg
c3BlY2lhbCwgYmVjYXVzZSBib3RoIERvbTAgYW5kIERvbVUgbXVzdCB1c2UgdGhpcy4KKyAqLwor
I2RlZmluZSBYRU5fTUNfZmV0Y2ggICAgICAgICAgICAxCitzdHJ1Y3QgeGVuX21jX2ZldGNoIHsK
KyAgICAvKiBJTi9PVVQgdmFyaWFibGVzLgorCSAqIElOOiBYRU5fTUNfTk9OVVJHRU5ULCBYRU5f
TUNfVVJHRU5ULAorCSAqIFhFTl9NQ19BQ0sgaWYgYWNrJ2tpbmcgYW4gZWFybGllciBmZXRjaAor
CSAqIE9VVDogWEVOX01DX09LLCBYRU5fTUNfRkVUQ0hBSUxFRCwKKwkgKiBYRU5fTUNfTk9EQVRB
LCBYRU5fTUNfTk9NQVRDSAorCSovCisJdWludDMyX3QgZmxhZ3M7CisJdWludDMyX3QgX3BhZDA7
CisJLyogT1VUOiBpZCBmb3IgYWNrLCBJTjogaWQgd2UgYXJlIGFjaydpbmcgKi8KKwl1aW50NjRf
dCBmZXRjaF9pZDsKKworCS8qIE9VVCB2YXJpYWJsZXMuICovCisJR1VFU1RfSEFORExFKG1jX2lu
Zm8pIGRhdGE7Cit9OwordHlwZWRlZiBzdHJ1Y3QgeGVuX21jX2ZldGNoIHhlbl9tY19mZXRjaF90
OworREVGSU5FX0dVRVNUX0hBTkRMRV9TVFJVQ1QoeGVuX21jX2ZldGNoKTsKKworCisvKiBVc2Vj
YXNlIDQKKyAqIFRoaXMgdGVsbHMgdGhlIGh5cGVydmlzb3IgdG8gbm90aWZ5IGEgRG9tVSBhYm91
dCB0aGUgbWFjaGluZSBjaGVjayBlcnJvcgorICovCisjZGVmaW5lIFhFTl9NQ19ub3RpZnlkb21h
aW4gICAgIDIKK3N0cnVjdCB4ZW5fbWNfbm90aWZ5ZG9tYWluIHsKKwkvKiBJTiB2YXJpYWJsZXMu
ICovCisJdWludDE2X3QgbWNfZG9taWQ7LyogVGhlIHVucHJpdmlsZWdlZCBkb21haW4gdG8gbm90
aWZ5LiAqLworCXVpbnQxNl90IG1jX3ZjcHVpZDsvKiBUaGUgdmNwdSBpbiBtY19kb21pZCB0byBu
b3RpZnkuCisJCQkqIFVzdWFsbHkgZWNobydkIHZhbHVlIGZyb20gdGhlIGZldGNoIGh5cGVyY2Fs
bC4gKi8KKworCS8qIElOL09VVCB2YXJpYWJsZXMuICovCisJdWludDMyX3QgZmxhZ3M7CisKKy8q
IE9VVDogWEVOX01DX09LLCBYRU5fTUNfQ0FOTk9USEFORExFLCBYRU5fTUNfTk9UREVMSVZFUkVE
LCBYRU5fTUNfTk9NQVRDSCAqLworfTsKK3R5cGVkZWYgc3RydWN0IHhlbl9tY19ub3RpZnlkb21h
aW4geGVuX21jX25vdGlmeWRvbWFpbl90OworREVGSU5FX0dVRVNUX0hBTkRMRV9TVFJVQ1QoeGVu
X21jX25vdGlmeWRvbWFpbik7CisKKyNkZWZpbmUgWEVOX01DX3BoeXNjcHVpbmZvIDMKK3N0cnVj
dCB4ZW5fbWNfcGh5c2NwdWluZm8geworCS8qIElOL09VVCAqLworCXVpbnQzMl90IG5jcHVzOwor
CXVpbnQzMl90IF9wYWQwOworCS8qIE9VVCAqLworCUdVRVNUX0hBTkRMRShtY2luZm9fbG9naWNh
bF9jcHUpIGluZm87Cit9OworCisjZGVmaW5lIFhFTl9NQ19tc3JpbmplY3QgICAgNAorI2RlZmlu
ZSBNQ19NU1JJTkpfTUFYTVNSUyAgICAgICA4CitzdHJ1Y3QgeGVuX21jX21zcmluamVjdCB7CisJ
LyogSU4gKi8KKwl1aW50MzJfdCBtY2lual9jcHVucjsvKiB0YXJnZXQgcHJvY2Vzc29yIGlkICov
CisJdWludDMyX3QgbWNpbmpfZmxhZ3M7Lyogc2VlIE1DX01TUklOSl9GXyogYmVsb3cgKi8KKwl1
aW50MzJfdCBtY2lual9jb3VudDsvKiAwIC4uIGNvdW50LTEgaW4gYXJyYXkgYXJlIHZhbGlkICov
CisJdWludDMyX3QgX3BhZDA7CisJc3RydWN0IG1jaW5mb19tc3IgbWNpbmpfbXNyW01DX01TUklO
Sl9NQVhNU1JTXTsKK307CisKKy8qIEZsYWdzIGZvciBtY2lual9mbGFncyBhYm92ZTsgYml0cyAx
Ni0zMSBhcmUgcmVzZXJ2ZWQgKi8KKyNkZWZpbmUgTUNfTVNSSU5KX0ZfSU5URVJQT1NFICAgMHgx
CisKKyNkZWZpbmUgWEVOX01DX21jZWluamVjdCAgICA1CitzdHJ1Y3QgeGVuX21jX21jZWluamVj
dCB7CisJdW5zaWduZWQgaW50IG1jZWlual9jcHVucjsgICAgICAvKiB0YXJnZXQgcHJvY2Vzc29y
IGlkICovCit9OworCitzdHJ1Y3QgeGVuX21jIHsKKwl1aW50MzJfdCBjbWQ7CisJdWludDMyX3Qg
aW50ZXJmYWNlX3ZlcnNpb247IC8qIFhFTl9NQ0FfSU5URVJGQUNFX1ZFUlNJT04gKi8KKwl1bmlv
biB7CisJCXN0cnVjdCB4ZW5fbWNfZmV0Y2ggICAgICAgIG1jX2ZldGNoOworCQlzdHJ1Y3QgeGVu
X21jX25vdGlmeWRvbWFpbiBtY19ub3RpZnlkb21haW47CisJCXN0cnVjdCB4ZW5fbWNfcGh5c2Nw
dWluZm8gIG1jX3BoeXNjcHVpbmZvOworCQlzdHJ1Y3QgeGVuX21jX21zcmluamVjdCAgICBtY19t
c3JpbmplY3Q7CisJCXN0cnVjdCB4ZW5fbWNfbWNlaW5qZWN0ICAgIG1jX21jZWluamVjdDsKKwl9
IHU7Cit9OwordHlwZWRlZiBzdHJ1Y3QgeGVuX21jIHhlbl9tY190OworREVGSU5FX0dVRVNUX0hB
TkRMRV9TVFJVQ1QoeGVuX21jKTsKKworI2VuZGlmIC8qIF9fQVNTRU1CTFlfXyAqLworCisjZW5k
aWYgLyogX19YRU5fUFVCTElDX0FSQ0hfWDg2X01DQV9IX18gKi8KLS0gCjEuNi41LjYKCg==

--_002_DE8DF0795D48FD4CA783C40EC82923359699SHSMSX101ccrcorpint_--
