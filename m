Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab2EVFpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 01:45:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:48569 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab2EVFpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 01:45:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="146092282"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (v2)
Thread-Topic: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (v2)
Thread-Index: Ac033gjpbJSbBggbSyWVZxOOOr38Zg==
Date: Tue, 22 May 2012 05:45:04 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351D6892@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923351D6892SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923351D6892SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 4df7496eea9e92a3e267ffb0a4b8f5e6e0c29c36 Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Mon, 21 May 2012 05:07:47 +0800
Subject: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform

When MCA error occurs, it would be handled by Xen hypervisor first,
and then the error information would be sent to initial domain for logging.

This patch gets error information from Xen hypervisor and convert
Xen format error into Linux format mcelog. This logic is basically
self-contained, not touching other kernel components.

By using tools like mcelog tool users could read specific error information=
,
like what they did under native Linux.

To test follow directions outlined in Documentation/acpi/apei/einj.txt

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
Signed-off-by: Ke, Liping <liping.ke@intel.com>
Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/xen/hypercall.h |    8 +
 arch/x86/kernel/cpu/mcheck/mce.c     |    4 +-
 arch/x86/xen/enlighten.c             |    9 +-
 drivers/xen/Kconfig                  |    8 +
 drivers/xen/Makefile                 |    1 +
 drivers/xen/mcelog.c                 |  395 ++++++++++++++++++++++++++++++=
++++
 include/linux/miscdevice.h           |    1 +
 include/xen/interface/xen-mca.h      |  389 ++++++++++++++++++++++++++++++=
+++
 8 files changed, 809 insertions(+), 6 deletions(-)
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
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/=
mce.c
index d086a09..24b2e86 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -57,8 +57,6 @@ static DEFINE_MUTEX(mce_chrdev_read_mutex);
=20
 int mce_disabled __read_mostly;
=20
-#define MISC_MCELOG_MINOR	227
-
 #define SPINUNIT 100	/* 100ns */
=20
 atomic_t mce_entry;
@@ -1791,7 +1789,7 @@ static const struct file_operations mce_chrdev_ops =
=3D {
 	.llseek			=3D no_llseek,
 };
=20
-static struct miscdevice mce_chrdev_device =3D {
+struct miscdevice mce_chrdev_device =3D {
 	MISC_MCELOG_MINOR,
 	"mcelog",
 	&mce_chrdev_ops,
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 4f51beb..13c568c 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -38,6 +38,7 @@
 #include <xen/interface/physdev.h>
 #include <xen/interface/vcpu.h>
 #include <xen/interface/memory.h>
+#include <xen/interface/xen-mca.h>
 #include <xen/features.h>
 #include <xen/page.h>
 #include <xen/hvm.h>
@@ -329,9 +330,7 @@ static void __init xen_init_cpuid_mask(void)
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
@@ -1270,6 +1269,10 @@ asmlinkage void __init xen_start_kernel(void)
 	set_xen_basic_apic_ops();
 #endif
=20
+#ifdef CONFIG_XEN_MCE_LOG
+	xen_early_init_mcelog();
+#endif
+
 	if (xen_feature(XENFEAT_mmu_pt_update_preserve_ad)) {
 		pv_mmu_ops.ptep_modify_prot_start =3D xen_ptep_modify_prot_start;
 		pv_mmu_ops.ptep_modify_prot_commit =3D xen_ptep_modify_prot_commit;
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
index 0000000..cd084b8
--- /dev/null
+++ b/drivers/xen/mcelog.c
@@ -0,0 +1,395 @@
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
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/device.h>
+#include <linux/miscdevice.h>
+#include <linux/uaccess.h>
+#include <linux/capability.h>
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
+static struct xen_mce_log xen_mcelog =3D {
+	.signature	=3D XEN_MCE_LOG_SIGNATURE,
+	.len		=3D XEN_MCE_LOG_LEN,
+	.recordlen	=3D sizeof(struct xen_mce),
+};
+
+static DEFINE_SPINLOCK(xen_mce_chrdev_state_lock);
+static int xen_mce_chrdev_open_count;	/* #times opened */
+static int xen_mce_chrdev_open_exclu;	/* already open exclusive? */
+
+static int xen_mce_chrdev_open(struct inode *inode, struct file *file)
+{
+	spin_lock(&xen_mce_chrdev_state_lock);
+
+	if (xen_mce_chrdev_open_exclu ||
+	    (xen_mce_chrdev_open_count && (file->f_flags & O_EXCL))) {
+		spin_unlock(&xen_mce_chrdev_state_lock);
+
+		return -EBUSY;
+	}
+
+	if (file->f_flags & O_EXCL)
+		xen_mce_chrdev_open_exclu =3D 1;
+	xen_mce_chrdev_open_count++;
+
+	spin_unlock(&xen_mce_chrdev_state_lock);
+
+	return nonseekable_open(inode, file);
+}
+
+static int xen_mce_chrdev_release(struct inode *inode, struct file *file)
+{
+	spin_lock(&xen_mce_chrdev_state_lock);
+
+	xen_mce_chrdev_open_count--;
+	xen_mce_chrdev_open_exclu =3D 0;
+
+	spin_unlock(&xen_mce_chrdev_state_lock);
+
+	return 0;
+}
+
+static ssize_t xen_mce_chrdev_read(struct file *filp, char __user *ubuf,
+				size_t usize, loff_t *off)
+{
+	char __user *buf =3D ubuf;
+	unsigned num;
+	int i, err;
+
+	spin_lock(&mcelog_lock);
+
+	num =3D xen_mcelog.next;
+
+	/* Only supports full reads right now */
+	err =3D -EINVAL;
+	if (*off !=3D 0 || usize < XEN_MCE_LOG_LEN*sizeof(struct xen_mce))
+		goto out;
+
+	err =3D 0;
+	for (i =3D 0; i < num; i++) {
+		struct xen_mce *m =3D &xen_mcelog.entry[i];
+
+		err |=3D copy_to_user(buf, m, sizeof(*m));
+		buf +=3D sizeof(*m);
+	}
+
+	memset(xen_mcelog.entry, 0, num * sizeof(struct xen_mce));
+	xen_mcelog.next =3D 0;
+
+	if (err)
+		err =3D -EFAULT;
+
+out:
+	spin_unlock(&mcelog_lock);
+
+	return err ? err : buf - ubuf;
+}
+
+static long xen_mce_chrdev_ioctl(struct file *f, unsigned int cmd,
+				unsigned long arg)
+{
+	int __user *p =3D (int __user *)arg;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	switch (cmd) {
+	case MCE_GET_RECORD_LEN:
+		return put_user(sizeof(struct xen_mce), p);
+	case MCE_GET_LOG_LEN:
+		return put_user(XEN_MCE_LOG_LEN, p);
+	case MCE_GETCLEAR_FLAGS: {
+		unsigned flags;
+
+		do {
+			flags =3D xen_mcelog.flags;
+		} while (cmpxchg(&xen_mcelog.flags, flags, 0) !=3D flags);
+
+		return put_user(flags, p);
+	}
+	default:
+		return -ENOTTY;
+	}
+}
+
+static const struct file_operations xen_mce_chrdev_ops =3D {
+	.open			=3D xen_mce_chrdev_open,
+	.release		=3D xen_mce_chrdev_release,
+	.read			=3D xen_mce_chrdev_read,
+	.unlocked_ioctl		=3D xen_mce_chrdev_ioctl,
+	.llseek			=3D no_llseek,
+};
+
+static struct miscdevice xen_mce_chrdev_device =3D {
+	MISC_MCELOG_MINOR,
+	"mcelog",
+	&xen_mce_chrdev_ops,
+};
+
+/*
+ * Caller should hold the mcelog_lock
+ */
+static void xen_mce_log(struct xen_mce *mce)
+{
+	unsigned entry;
+
+	entry =3D xen_mcelog.next;
+
+	/*
+	 * When the buffer fills up discard new entries.
+	 * Assume that the earlier errors are the more
+	 * interesting ones:
+	 */
+	if (entry >=3D XEN_MCE_LOG_LEN) {
+		set_bit(XEN_MCE_OVERFLOW,
+			(unsigned long *)&xen_mcelog.flags);
+		return;
+	}
+
+	memcpy(xen_mcelog.entry + entry, mce, sizeof(struct xen_mce));
+
+	xen_mcelog.next++;
+}
+
+static int convert_log(struct mc_info *mi)
+{
+	struct mcinfo_common *mic;
+	struct mcinfo_global *mc_global;
+	struct mcinfo_bank *mc_bank;
+	struct xen_mce m;
+	uint32_t i;
+
+	mic =3D NULL;
+	x86_mcinfo_lookup(&mic, mi, MC_TYPE_GLOBAL);
+	if (unlikely(!mic)) {
+		pr_warning(XEN_MCELOG "Failed to find global error info\n");
+		return -ENODEV;
+	}
+
+	memset(&m, 0, sizeof(struct xen_mce));
+
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
+			xen_mce_log(&m);
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
+	return ret;
+}
+
+/* virq handler for machine check error info*/
+static irqreturn_t xen_mce_interrupt(int irq, void *dev_id)
+{
+	int err;
+	unsigned long tmp;
+
+	spin_lock_irqsave(&mcelog_lock, tmp);
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
+	spin_unlock_irqrestore(&mcelog_lock, tmp);
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
+void __init xen_early_init_mcelog(void)
+{
+	/* Only DOM0 is responsible for MCE logging */
+	if (xen_initial_domain())
+		mce_chrdev_device =3D xen_mce_chrdev_device;
+}
+
+static int __init xen_late_init_mcelog(void)
+{
+	/* Only DOM0 is responsible for MCE logging */
+	if (xen_initial_domain())
+		return bind_virq_for_mce();
+
+	return -ENODEV;
+}
+late_initcall(xen_late_init_mcelog);
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 0549d21..e0deeb2 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -35,6 +35,7 @@
 #define MPT_MINOR		220
 #define MPT2SAS_MINOR		221
 #define UINPUT_MINOR		223
+#define MISC_MCELOG_MINOR	227
 #define HPET_MINOR		228
 #define FUSE_MINOR		229
 #define KVM_MINOR		232
diff --git a/include/xen/interface/xen-mca.h b/include/xen/interface/xen-mc=
a.h
new file mode 100644
index 0000000..f6e4fef
--- /dev/null
+++ b/include/xen/interface/xen-mca.h
@@ -0,0 +1,389 @@
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
+extern struct miscdevice mce_chrdev_device;
+
+void xen_early_init_mcelog(void);
+
+/* Fields are zero when not available */
+struct xen_mce {
+	__u64 status;
+	__u64 misc;
+	__u64 addr;
+	__u64 mcgstatus;
+	__u64 ip;
+	__u64 tsc;	/* cpu time stamp counter */
+	__u64 time;	/* wall time_t when error was detected */
+	__u8  cpuvendor;	/* cpu vendor as encoded in system.h */
+	__u8  inject_flags;	/* software inject flags */
+	__u16  pad;
+	__u32 cpuid;	/* CPUID 1 EAX */
+	__u8  cs;		/* code segment */
+	__u8  bank;	/* machine check bank */
+	__u8  cpu;	/* cpu number; obsolete; use extcpu now */
+	__u8  finished;   /* entry is valid */
+	__u32 extcpu;	/* linux cpu number that detected the error */
+	__u32 socketid;	/* CPU socket ID */
+	__u32 apicid;	/* CPU initial apic ID */
+	__u64 mcgcap;	/* MCGCAP MSR: machine check capabilities of CPU */
+};
+
+/*
+ * This structure contains all data related to the MCE log.  Also
+ * carries a signature to make it easier to find from external
+ * debugging tools.  Each entry is only valid when its finished flag
+ * is set.
+ */
+
+#define XEN_MCE_LOG_LEN 32
+
+struct xen_mce_log {
+	char signature[12]; /* "MACHINECHECK" */
+	unsigned len;	    /* =3D XEN_MCE_LOG_LEN */
+	unsigned next;
+	unsigned flags;
+	unsigned recordlen;	/* length of struct xen_mce */
+	struct xen_mce entry[XEN_MCE_LOG_LEN];
+};
+
+#define XEN_MCE_OVERFLOW 0		/* bit 0 in flags means overflow */
+
+#define XEN_MCE_LOG_SIGNATURE	"MACHINECHECK"
+
+#define MCE_GET_RECORD_LEN   _IOR('M', 1, int)
+#define MCE_GET_LOG_LEN      _IOR('M', 2, int)
+#define MCE_GETCLEAR_FLAGS   _IOR('M', 3, int)
+
+#endif /* __ASSEMBLY__ */
+#endif /* __XEN_PUBLIC_ARCH_X86_MCA_H__ */
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923351D6892SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-xen-mce-Add-mcelog-support-for-Xen-platform.patch"
Content-Description: 0001-xen-mce-Add-mcelog-support-for-Xen-platform.patch
Content-Disposition: attachment;
	filename="0001-xen-mce-Add-mcelog-support-for-Xen-platform.patch";
	size=27590; creation-date="Tue, 22 May 2012 05:39:36 GMT";
	modification-date="Tue, 22 May 2012 13:34:16 GMT"
Content-Transfer-Encoding: base64

RnJvbSA0ZGY3NDk2ZWVhOWU5MmEzZTI2N2ZmYjBhNGI4ZjVlNmUwYzI5YzM2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogTW9uLCAyMSBNYXkgMjAxMiAwNTowNzo0NyArMDgwMApTdWJqZWN0OiBbUEFUQ0ggMS8z
XSB4ZW4vbWNlOiBBZGQgbWNlbG9nIHN1cHBvcnQgZm9yIFhlbiBwbGF0Zm9ybQoKV2hlbiBNQ0Eg
ZXJyb3Igb2NjdXJzLCBpdCB3b3VsZCBiZSBoYW5kbGVkIGJ5IFhlbiBoeXBlcnZpc29yIGZpcnN0
LAphbmQgdGhlbiB0aGUgZXJyb3IgaW5mb3JtYXRpb24gd291bGQgYmUgc2VudCB0byBpbml0aWFs
IGRvbWFpbiBmb3IgbG9nZ2luZy4KClRoaXMgcGF0Y2ggZ2V0cyBlcnJvciBpbmZvcm1hdGlvbiBm
cm9tIFhlbiBoeXBlcnZpc29yIGFuZCBjb252ZXJ0ClhlbiBmb3JtYXQgZXJyb3IgaW50byBMaW51
eCBmb3JtYXQgbWNlbG9nLiBUaGlzIGxvZ2ljIGlzIGJhc2ljYWxseQpzZWxmLWNvbnRhaW5lZCwg
bm90IHRvdWNoaW5nIG90aGVyIGtlcm5lbCBjb21wb25lbnRzLgoKQnkgdXNpbmcgdG9vbHMgbGlr
ZSBtY2Vsb2cgdG9vbCB1c2VycyBjb3VsZCByZWFkIHNwZWNpZmljIGVycm9yIGluZm9ybWF0aW9u
LApsaWtlIHdoYXQgdGhleSBkaWQgdW5kZXIgbmF0aXZlIExpbnV4LgoKVG8gdGVzdCBmb2xsb3cg
ZGlyZWN0aW9ucyBvdXRsaW5lZCBpbiBEb2N1bWVudGF0aW9uL2FjcGkvYXBlaS9laW5qLnR4dAoK
U2lnbmVkLW9mZi1ieTogTGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+ClNpZ25l
ZC1vZmYtYnk6IEtlLCBMaXBpbmcgPGxpcGluZy5rZUBpbnRlbC5jb20+ClNpZ25lZC1vZmYtYnk6
IEppYW5nLCBZdW5ob25nIDx5dW5ob25nLmppYW5nQGludGVsLmNvbT4KU2lnbmVkLW9mZi1ieTog
SmVyZW15IEZpdHpoYXJkaW5nZSA8amVyZW15LmZpdHpoYXJkaW5nZUBjaXRyaXguY29tPgotLS0K
IGFyY2gveDg2L2luY2x1ZGUvYXNtL3hlbi9oeXBlcmNhbGwuaCB8ICAgIDggKwogYXJjaC94ODYv
a2VybmVsL2NwdS9tY2hlY2svbWNlLmMgICAgIHwgICAgNCArLQogYXJjaC94ODYveGVuL2VubGln
aHRlbi5jICAgICAgICAgICAgIHwgICAgOSArLQogZHJpdmVycy94ZW4vS2NvbmZpZyAgICAgICAg
ICAgICAgICAgIHwgICAgOCArCiBkcml2ZXJzL3hlbi9NYWtlZmlsZSAgICAgICAgICAgICAgICAg
fCAgICAxICsKIGRyaXZlcnMveGVuL21jZWxvZy5jICAgICAgICAgICAgICAgICB8ICAzOTUgKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogaW5jbHVkZS9saW51eC9taXNjZGV2aWNl
LmggICAgICAgICAgIHwgICAgMSArCiBpbmNsdWRlL3hlbi9pbnRlcmZhY2UveGVuLW1jYS5oICAg
ICAgfCAgMzg5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogOCBmaWxlcyBjaGFu
Z2VkLCA4MDkgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKIGNyZWF0ZSBtb2RlIDEwMDY0
NCBkcml2ZXJzL3hlbi9tY2Vsb2cuYwogY3JlYXRlIG1vZGUgMTAwNjQ0IGluY2x1ZGUveGVuL2lu
dGVyZmFjZS94ZW4tbWNhLmgKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS94ZW4v
aHlwZXJjYWxsLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS94ZW4vaHlwZXJjYWxsLmgKaW5kZXgg
NTcyODg1Mi4uNTljMjI2ZCAxMDA2NDQKLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20veGVuL2h5
cGVyY2FsbC5oCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3hlbi9oeXBlcmNhbGwuaApAQCAt
NDgsNiArNDgsNyBAQAogI2luY2x1ZGUgPHhlbi9pbnRlcmZhY2Uvc2NoZWQuaD4KICNpbmNsdWRl
IDx4ZW4vaW50ZXJmYWNlL3BoeXNkZXYuaD4KICNpbmNsdWRlIDx4ZW4vaW50ZXJmYWNlL3BsYXRm
b3JtLmg+CisjaW5jbHVkZSA8eGVuL2ludGVyZmFjZS94ZW4tbWNhLmg+CiAKIC8qCiAgKiBUaGUg
aHlwZXJjYWxsIGFzbXMgaGF2ZSB0byBtZWV0IHNldmVyYWwgY29uc3RyYWludHM6CkBAIC0zMDIs
NiArMzAzLDEzIEBAIEhZUEVSVklTT1Jfc2V0X3RpbWVyX29wKHU2NCB0aW1lb3V0KQogfQogCiBz
dGF0aWMgaW5saW5lIGludAorSFlQRVJWSVNPUl9tY2Eoc3RydWN0IHhlbl9tYyAqbWNfb3ApCit7
CisJbWNfb3AtPmludGVyZmFjZV92ZXJzaW9uID0gWEVOX01DQV9JTlRFUkZBQ0VfVkVSU0lPTjsK
KwlyZXR1cm4gX2h5cGVyY2FsbDEoaW50LCBtY2EsIG1jX29wKTsKK30KKworc3RhdGljIGlubGlu
ZSBpbnQKIEhZUEVSVklTT1JfZG9tMF9vcChzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wICpwbGF0Zm9y
bV9vcCkKIHsKIAlwbGF0Zm9ybV9vcC0+aW50ZXJmYWNlX3ZlcnNpb24gPSBYRU5QRl9JTlRFUkZB
Q0VfVkVSU0lPTjsKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvbWNoZWNrL21jZS5j
IGIvYXJjaC94ODYva2VybmVsL2NwdS9tY2hlY2svbWNlLmMKaW5kZXggZDA4NmEwOS4uMjRiMmU4
NiAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9tY2hlY2svbWNlLmMKKysrIGIvYXJj
aC94ODYva2VybmVsL2NwdS9tY2hlY2svbWNlLmMKQEAgLTU3LDggKzU3LDYgQEAgc3RhdGljIERF
RklORV9NVVRFWChtY2VfY2hyZGV2X3JlYWRfbXV0ZXgpOwogCiBpbnQgbWNlX2Rpc2FibGVkIF9f
cmVhZF9tb3N0bHk7CiAKLSNkZWZpbmUgTUlTQ19NQ0VMT0dfTUlOT1IJMjI3Ci0KICNkZWZpbmUg
U1BJTlVOSVQgMTAwCS8qIDEwMG5zICovCiAKIGF0b21pY190IG1jZV9lbnRyeTsKQEAgLTE3OTEs
NyArMTc4OSw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIG1jZV9jaHJk
ZXZfb3BzID0gewogCS5sbHNlZWsJCQk9IG5vX2xsc2VlaywKIH07CiAKLXN0YXRpYyBzdHJ1Y3Qg
bWlzY2RldmljZSBtY2VfY2hyZGV2X2RldmljZSA9IHsKK3N0cnVjdCBtaXNjZGV2aWNlIG1jZV9j
aHJkZXZfZGV2aWNlID0gewogCU1JU0NfTUNFTE9HX01JTk9SLAogCSJtY2Vsb2ciLAogCSZtY2Vf
Y2hyZGV2X29wcywKZGlmZiAtLWdpdCBhL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYyBiL2FyY2gv
eDg2L3hlbi9lbmxpZ2h0ZW4uYwppbmRleCA0ZjUxYmViLi4xM2M1NjhjIDEwMDY0NAotLS0gYS9h
cmNoL3g4Ni94ZW4vZW5saWdodGVuLmMKKysrIGIvYXJjaC94ODYveGVuL2VubGlnaHRlbi5jCkBA
IC0zOCw2ICszOCw3IEBACiAjaW5jbHVkZSA8eGVuL2ludGVyZmFjZS9waHlzZGV2Lmg+CiAjaW5j
bHVkZSA8eGVuL2ludGVyZmFjZS92Y3B1Lmg+CiAjaW5jbHVkZSA8eGVuL2ludGVyZmFjZS9tZW1v
cnkuaD4KKyNpbmNsdWRlIDx4ZW4vaW50ZXJmYWNlL3hlbi1tY2EuaD4KICNpbmNsdWRlIDx4ZW4v
ZmVhdHVyZXMuaD4KICNpbmNsdWRlIDx4ZW4vcGFnZS5oPgogI2luY2x1ZGUgPHhlbi9odm0uaD4K
QEAgLTMyOSw5ICszMzAsNyBAQCBzdGF0aWMgdm9pZCBfX2luaXQgeGVuX2luaXRfY3B1aWRfbWFz
ayh2b2lkKQogCXVuc2lnbmVkIGludCB4c2F2ZV9tYXNrOwogCiAJY3B1aWRfbGVhZjFfZWR4X21h
c2sgPQotCQl+KCgxIDw8IFg4Nl9GRUFUVVJFX01DRSkgIHwgIC8qIGRpc2FibGUgTUNFICovCi0J
CSAgKDEgPDwgWDg2X0ZFQVRVUkVfTUNBKSAgfCAgLyogZGlzYWJsZSBNQ0EgKi8KLQkJICAoMSA8
PCBYODZfRkVBVFVSRV9NVFJSKSB8ICAvKiBkaXNhYmxlIE1UUlIgKi8KKwkJfigoMSA8PCBYODZf
RkVBVFVSRV9NVFJSKSB8ICAvKiBkaXNhYmxlIE1UUlIgKi8KIAkJICAoMSA8PCBYODZfRkVBVFVS
RV9BQ0MpKTsgICAvKiB0aGVybWFsIG1vbml0b3JpbmcgKi8KIAogCWlmICgheGVuX2luaXRpYWxf
ZG9tYWluKCkpCkBAIC0xMjcwLDYgKzEyNjksMTAgQEAgYXNtbGlua2FnZSB2b2lkIF9faW5pdCB4
ZW5fc3RhcnRfa2VybmVsKHZvaWQpCiAJc2V0X3hlbl9iYXNpY19hcGljX29wcygpOwogI2VuZGlm
CiAKKyNpZmRlZiBDT05GSUdfWEVOX01DRV9MT0cKKwl4ZW5fZWFybHlfaW5pdF9tY2Vsb2coKTsK
KyNlbmRpZgorCiAJaWYgKHhlbl9mZWF0dXJlKFhFTkZFQVRfbW11X3B0X3VwZGF0ZV9wcmVzZXJ2
ZV9hZCkpIHsKIAkJcHZfbW11X29wcy5wdGVwX21vZGlmeV9wcm90X3N0YXJ0ID0geGVuX3B0ZXBf
bW9kaWZ5X3Byb3Rfc3RhcnQ7CiAJCXB2X21tdV9vcHMucHRlcF9tb2RpZnlfcHJvdF9jb21taXQg
PSB4ZW5fcHRlcF9tb2RpZnlfcHJvdF9jb21taXQ7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi9L
Y29uZmlnIGIvZHJpdmVycy94ZW4vS2NvbmZpZwppbmRleCA5NDI0MzEzLi4wZjU0MjQxIDEwMDY0
NAotLS0gYS9kcml2ZXJzL3hlbi9LY29uZmlnCisrKyBiL2RyaXZlcnMveGVuL0tjb25maWcKQEAg
LTE5NCw0ICsxOTQsMTIgQEAgY29uZmlnIFhFTl9BQ1BJX1BST0NFU1NPUgogICAgICAgICAgIG1v
ZHVsZSB3aWxsIGJlIGNhbGxlZCB4ZW5fYWNwaV9wcm9jZXNzb3IgIElmIHlvdSBkbyBub3Qga25v
dyB3aGF0IHRvIGNob29zZSwKICAgICAgICAgICBzZWxlY3QgTSBoZXJlLiBJZiB0aGUgQ1BVRlJF
USBkcml2ZXJzIGFyZSBidWlsdCBpbiwgc2VsZWN0IFkgaGVyZS4KIAorY29uZmlnIFhFTl9NQ0Vf
TE9HCisJYm9vbCAiWGVuIHBsYXRmb3JtIG1jZWxvZyIKKwlkZXBlbmRzIG9uIFhFTl9ET00wICYm
IFg4Nl82NCAmJiBYODZfTUNFCisJZGVmYXVsdCBuCisJaGVscAorCSAgQWxsb3cga2VybmVsIGZl
dGNoaW5nIE1DRSBlcnJvciBmcm9tIFhlbiBwbGF0Zm9ybSBhbmQKKwkgIGNvbnZlcnRpbmcgaXQg
aW50byBMaW51eCBtY2Vsb2cgZm9ybWF0IGZvciBtY2Vsb2cgdG9vbHMKKwogZW5kbWVudQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy94ZW4vTWFrZWZpbGUgYi9kcml2ZXJzL3hlbi9NYWtlZmlsZQppbmRl
eCA5YWRjNWJlLi4xZDNlNzYzIDEwMDY0NAotLS0gYS9kcml2ZXJzL3hlbi9NYWtlZmlsZQorKysg
Yi9kcml2ZXJzL3hlbi9NYWtlZmlsZQpAQCAtMTQsNiArMTQsNyBAQCBvYmotJChDT05GSUdfWEVO
X0dOVERFVikJCSs9IHhlbi1nbnRkZXYubwogb2JqLSQoQ09ORklHX1hFTl9HUkFOVF9ERVZfQUxM
T0MpCSs9IHhlbi1nbnRhbGxvYy5vCiBvYmotJChDT05GSUdfWEVORlMpCQkJKz0geGVuZnMvCiBv
YmotJChDT05GSUdfWEVOX1NZU19IWVBFUlZJU09SKQkrPSBzeXMtaHlwZXJ2aXNvci5vCitvYmot
JChDT05GSUdfWEVOX01DRV9MT0cpCQkrPSBtY2Vsb2cubwogb2JqLSQoQ09ORklHX1hFTl9QVkhW
TSkJCQkrPSBwbGF0Zm9ybS1wY2kubwogb2JqLSQoQ09ORklHX1hFTl9UTUVNKQkJCSs9IHRtZW0u
bwogb2JqLSQoQ09ORklHX1NXSU9UTEJfWEVOKQkJKz0gc3dpb3RsYi14ZW4ubwpkaWZmIC0tZ2l0
IGEvZHJpdmVycy94ZW4vbWNlbG9nLmMgYi9kcml2ZXJzL3hlbi9tY2Vsb2cuYwpuZXcgZmlsZSBt
b2RlIDEwMDY0NAppbmRleCAwMDAwMDAwLi5jZDA4NGI4Ci0tLSAvZGV2L251bGwKKysrIGIvZHJp
dmVycy94ZW4vbWNlbG9nLmMKQEAgLTAsMCArMSwzOTUgQEAKKy8qKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioKKyAqIG1jZWxvZy5jCisgKiBEcml2ZXIgZm9yIHJlY2VpdmluZyBhbmQgdHJhbnNmZXJyaW5n
IG1hY2hpbmUgY2hlY2sgZXJyb3IgaW5mb21hdGlvbgorICoKKyAqIENvcHlyaWdodCAoYykgMjAx
MiBJbnRlbCBDb3Jwb3JhdGlvbgorICogQXV0aG9yOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1
QGludGVsLmNvbT4KKyAqIEF1dGhvcjogSmlhbmcsIFl1bmhvbmcgPHl1bmhvbmcuamlhbmdAaW50
ZWwuY29tPgorICogQXV0aG9yOiBLZSwgTGlwaW5nIDxsaXBpbmcua2VAaW50ZWwuY29tPgorICoK
KyAqIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBp
dCBhbmQvb3IKKyAqIG1vZGlmeSBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFs
IFB1YmxpYyBMaWNlbnNlIHZlcnNpb24gMgorICogYXMgcHVibGlzaGVkIGJ5IHRoZSBGcmVlIFNv
ZnR3YXJlIEZvdW5kYXRpb247IG9yLCB3aGVuIGRpc3RyaWJ1dGVkCisgKiBzZXBhcmF0ZWx5IGZy
b20gdGhlIExpbnV4IGtlcm5lbCBvciBpbmNvcnBvcmF0ZWQgaW50byBvdGhlcgorICogc29mdHdh
cmUgcGFja2FnZXMsIHN1YmplY3QgdG8gdGhlIGZvbGxvd2luZyBsaWNlbnNlOgorICoKKyAqIFBl
cm1pc3Npb24gaXMgaGVyZWJ5IGdyYW50ZWQsIGZyZWUgb2YgY2hhcmdlLCB0byBhbnkgcGVyc29u
IG9idGFpbmluZyBhIGNvcHkKKyAqIG9mIHRoaXMgc291cmNlIGZpbGUgKHRoZSAiU29mdHdhcmUi
KSwgdG8gZGVhbCBpbiB0aGUgU29mdHdhcmUgd2l0aG91dAorICogcmVzdHJpY3Rpb24sIGluY2x1
ZGluZyB3aXRob3V0IGxpbWl0YXRpb24gdGhlIHJpZ2h0cyB0byB1c2UsIGNvcHksIG1vZGlmeSwK
KyAqIG1lcmdlLCBwdWJsaXNoLCBkaXN0cmlidXRlLCBzdWJsaWNlbnNlLCBhbmQvb3Igc2VsbCBj
b3BpZXMgb2YgdGhlIFNvZnR3YXJlLAorICogYW5kIHRvIHBlcm1pdCBwZXJzb25zIHRvIHdob20g
dGhlIFNvZnR3YXJlIGlzIGZ1cm5pc2hlZCB0byBkbyBzbywgc3ViamVjdCB0bworICogdGhlIGZv
bGxvd2luZyBjb25kaXRpb25zOgorICoKKyAqIFRoZSBhYm92ZSBjb3B5cmlnaHQgbm90aWNlIGFu
ZCB0aGlzIHBlcm1pc3Npb24gbm90aWNlIHNoYWxsIGJlIGluY2x1ZGVkIGluCisgKiBhbGwgY29w
aWVzIG9yIHN1YnN0YW50aWFsIHBvcnRpb25zIG9mIHRoZSBTb2Z0d2FyZS4KKyAqCisgKiBUSEUg
U09GVFdBUkUgSVMgUFJPVklERUQgIkFTIElTIiwgV0lUSE9VVCBXQVJSQU5UWSBPRiBBTlkgS0lO
RCwgRVhQUkVTUyBPUgorICogSU1QTElFRCwgSU5DTFVESU5HIEJVVCBOT1QgTElNSVRFRCBUTyBU
SEUgV0FSUkFOVElFUyBPRiBNRVJDSEFOVEFCSUxJVFksCisgKiBGSVRORVNTIEZPUiBBIFBBUlRJ
Q1VMQVIgUFVSUE9TRSBBTkQgTk9OSU5GUklOR0VNRU5ULiBJTiBOTyBFVkVOVCBTSEFMTCBUSEUK
KyAqIEFVVEhPUlMgT1IgQ09QWVJJR0hUIEhPTERFUlMgQkUgTElBQkxFIEZPUiBBTlkgQ0xBSU0s
IERBTUFHRVMgT1IgT1RIRVIKKyAqIExJQUJJTElUWSwgV0hFVEhFUiBJTiBBTiBBQ1RJT04gT0Yg
Q09OVFJBQ1QsIFRPUlQgT1IgT1RIRVJXSVNFLCBBUklTSU5HCisgKiBGUk9NLCBPVVQgT0YgT1Ig
SU4gQ09OTkVDVElPTiBXSVRIIFRIRSBTT0ZUV0FSRSBPUiBUSEUgVVNFIE9SIE9USEVSIERFQUxJ
TkdTCisgKiBJTiBUSEUgU09GVFdBUkUuCisgKi8KKworI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4K
KyNpbmNsdWRlIDxsaW51eC90eXBlcy5oPgorI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgorI2lu
Y2x1ZGUgPGxpbnV4L3NsYWIuaD4KKyNpbmNsdWRlIDxsaW51eC9mcy5oPgorI2luY2x1ZGUgPGxp
bnV4L2RldmljZS5oPgorI2luY2x1ZGUgPGxpbnV4L21pc2NkZXZpY2UuaD4KKyNpbmNsdWRlIDxs
aW51eC91YWNjZXNzLmg+CisjaW5jbHVkZSA8bGludXgvY2FwYWJpbGl0eS5oPgorCisjaW5jbHVk
ZSA8eGVuL2ludGVyZmFjZS94ZW4uaD4KKyNpbmNsdWRlIDx4ZW4vZXZlbnRzLmg+CisjaW5jbHVk
ZSA8eGVuL2ludGVyZmFjZS92Y3B1Lmg+CisjaW5jbHVkZSA8eGVuL3hlbi5oPgorI2luY2x1ZGUg
PGFzbS94ZW4vaHlwZXJjYWxsLmg+CisjaW5jbHVkZSA8YXNtL3hlbi9oeXBlcnZpc29yLmg+CisK
KyNkZWZpbmUgWEVOX01DRUxPRyAieGVuX21jZWxvZzogIgorCitzdGF0aWMgc3RydWN0IG1jX2lu
Zm8gZ19taTsKK3N0YXRpYyBzdHJ1Y3QgbWNpbmZvX2xvZ2ljYWxfY3B1ICpnX3BoeXNpbmZvOwor
c3RhdGljIHVpbnQzMl90IG5jcHVzOworCitzdGF0aWMgREVGSU5FX1NQSU5MT0NLKG1jZWxvZ19s
b2NrKTsKKworc3RhdGljIHN0cnVjdCB4ZW5fbWNlX2xvZyB4ZW5fbWNlbG9nID0geworCS5zaWdu
YXR1cmUJPSBYRU5fTUNFX0xPR19TSUdOQVRVUkUsCisJLmxlbgkJPSBYRU5fTUNFX0xPR19MRU4s
CisJLnJlY29yZGxlbgk9IHNpemVvZihzdHJ1Y3QgeGVuX21jZSksCit9OworCitzdGF0aWMgREVG
SU5FX1NQSU5MT0NLKHhlbl9tY2VfY2hyZGV2X3N0YXRlX2xvY2spOworc3RhdGljIGludCB4ZW5f
bWNlX2NocmRldl9vcGVuX2NvdW50OwkvKiAjdGltZXMgb3BlbmVkICovCitzdGF0aWMgaW50IHhl
bl9tY2VfY2hyZGV2X29wZW5fZXhjbHU7CS8qIGFscmVhZHkgb3BlbiBleGNsdXNpdmU/ICovCisK
K3N0YXRpYyBpbnQgeGVuX21jZV9jaHJkZXZfb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1
Y3QgZmlsZSAqZmlsZSkKK3sKKwlzcGluX2xvY2soJnhlbl9tY2VfY2hyZGV2X3N0YXRlX2xvY2sp
OworCisJaWYgKHhlbl9tY2VfY2hyZGV2X29wZW5fZXhjbHUgfHwKKwkgICAgKHhlbl9tY2VfY2hy
ZGV2X29wZW5fY291bnQgJiYgKGZpbGUtPmZfZmxhZ3MgJiBPX0VYQ0wpKSkgeworCQlzcGluX3Vu
bG9jaygmeGVuX21jZV9jaHJkZXZfc3RhdGVfbG9jayk7CisKKwkJcmV0dXJuIC1FQlVTWTsKKwl9
CisKKwlpZiAoZmlsZS0+Zl9mbGFncyAmIE9fRVhDTCkKKwkJeGVuX21jZV9jaHJkZXZfb3Blbl9l
eGNsdSA9IDE7CisJeGVuX21jZV9jaHJkZXZfb3Blbl9jb3VudCsrOworCisJc3Bpbl91bmxvY2so
Jnhlbl9tY2VfY2hyZGV2X3N0YXRlX2xvY2spOworCisJcmV0dXJuIG5vbnNlZWthYmxlX29wZW4o
aW5vZGUsIGZpbGUpOworfQorCitzdGF0aWMgaW50IHhlbl9tY2VfY2hyZGV2X3JlbGVhc2Uoc3Ry
dWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpCit7CisJc3Bpbl9sb2NrKCZ4ZW5f
bWNlX2NocmRldl9zdGF0ZV9sb2NrKTsKKworCXhlbl9tY2VfY2hyZGV2X29wZW5fY291bnQtLTsK
Kwl4ZW5fbWNlX2NocmRldl9vcGVuX2V4Y2x1ID0gMDsKKworCXNwaW5fdW5sb2NrKCZ4ZW5fbWNl
X2NocmRldl9zdGF0ZV9sb2NrKTsKKworCXJldHVybiAwOworfQorCitzdGF0aWMgc3NpemVfdCB4
ZW5fbWNlX2NocmRldl9yZWFkKHN0cnVjdCBmaWxlICpmaWxwLCBjaGFyIF9fdXNlciAqdWJ1ZiwK
KwkJCQlzaXplX3QgdXNpemUsIGxvZmZfdCAqb2ZmKQoreworCWNoYXIgX191c2VyICpidWYgPSB1
YnVmOworCXVuc2lnbmVkIG51bTsKKwlpbnQgaSwgZXJyOworCisJc3Bpbl9sb2NrKCZtY2Vsb2df
bG9jayk7CisKKwludW0gPSB4ZW5fbWNlbG9nLm5leHQ7CisKKwkvKiBPbmx5IHN1cHBvcnRzIGZ1
bGwgcmVhZHMgcmlnaHQgbm93ICovCisJZXJyID0gLUVJTlZBTDsKKwlpZiAoKm9mZiAhPSAwIHx8
IHVzaXplIDwgWEVOX01DRV9MT0dfTEVOKnNpemVvZihzdHJ1Y3QgeGVuX21jZSkpCisJCWdvdG8g
b3V0OworCisJZXJyID0gMDsKKwlmb3IgKGkgPSAwOyBpIDwgbnVtOyBpKyspIHsKKwkJc3RydWN0
IHhlbl9tY2UgKm0gPSAmeGVuX21jZWxvZy5lbnRyeVtpXTsKKworCQllcnIgfD0gY29weV90b191
c2VyKGJ1ZiwgbSwgc2l6ZW9mKCptKSk7CisJCWJ1ZiArPSBzaXplb2YoKm0pOworCX0KKworCW1l
bXNldCh4ZW5fbWNlbG9nLmVudHJ5LCAwLCBudW0gKiBzaXplb2Yoc3RydWN0IHhlbl9tY2UpKTsK
Kwl4ZW5fbWNlbG9nLm5leHQgPSAwOworCisJaWYgKGVycikKKwkJZXJyID0gLUVGQVVMVDsKKwor
b3V0OgorCXNwaW5fdW5sb2NrKCZtY2Vsb2dfbG9jayk7CisKKwlyZXR1cm4gZXJyID8gZXJyIDog
YnVmIC0gdWJ1ZjsKK30KKworc3RhdGljIGxvbmcgeGVuX21jZV9jaHJkZXZfaW9jdGwoc3RydWN0
IGZpbGUgKmYsIHVuc2lnbmVkIGludCBjbWQsCisJCQkJdW5zaWduZWQgbG9uZyBhcmcpCit7CisJ
aW50IF9fdXNlciAqcCA9IChpbnQgX191c2VyICopYXJnOworCisJaWYgKCFjYXBhYmxlKENBUF9T
WVNfQURNSU4pKQorCQlyZXR1cm4gLUVQRVJNOworCisJc3dpdGNoIChjbWQpIHsKKwljYXNlIE1D
RV9HRVRfUkVDT1JEX0xFTjoKKwkJcmV0dXJuIHB1dF91c2VyKHNpemVvZihzdHJ1Y3QgeGVuX21j
ZSksIHApOworCWNhc2UgTUNFX0dFVF9MT0dfTEVOOgorCQlyZXR1cm4gcHV0X3VzZXIoWEVOX01D
RV9MT0dfTEVOLCBwKTsKKwljYXNlIE1DRV9HRVRDTEVBUl9GTEFHUzogeworCQl1bnNpZ25lZCBm
bGFnczsKKworCQlkbyB7CisJCQlmbGFncyA9IHhlbl9tY2Vsb2cuZmxhZ3M7CisJCX0gd2hpbGUg
KGNtcHhjaGcoJnhlbl9tY2Vsb2cuZmxhZ3MsIGZsYWdzLCAwKSAhPSBmbGFncyk7CisKKwkJcmV0
dXJuIHB1dF91c2VyKGZsYWdzLCBwKTsKKwl9CisJZGVmYXVsdDoKKwkJcmV0dXJuIC1FTk9UVFk7
CisJfQorfQorCitzdGF0aWMgY29uc3Qgc3RydWN0IGZpbGVfb3BlcmF0aW9ucyB4ZW5fbWNlX2No
cmRldl9vcHMgPSB7CisJLm9wZW4JCQk9IHhlbl9tY2VfY2hyZGV2X29wZW4sCisJLnJlbGVhc2UJ
CT0geGVuX21jZV9jaHJkZXZfcmVsZWFzZSwKKwkucmVhZAkJCT0geGVuX21jZV9jaHJkZXZfcmVh
ZCwKKwkudW5sb2NrZWRfaW9jdGwJCT0geGVuX21jZV9jaHJkZXZfaW9jdGwsCisJLmxsc2VlawkJ
CT0gbm9fbGxzZWVrLAorfTsKKworc3RhdGljIHN0cnVjdCBtaXNjZGV2aWNlIHhlbl9tY2VfY2hy
ZGV2X2RldmljZSA9IHsKKwlNSVNDX01DRUxPR19NSU5PUiwKKwkibWNlbG9nIiwKKwkmeGVuX21j
ZV9jaHJkZXZfb3BzLAorfTsKKworLyoKKyAqIENhbGxlciBzaG91bGQgaG9sZCB0aGUgbWNlbG9n
X2xvY2sKKyAqLworc3RhdGljIHZvaWQgeGVuX21jZV9sb2coc3RydWN0IHhlbl9tY2UgKm1jZSkK
K3sKKwl1bnNpZ25lZCBlbnRyeTsKKworCWVudHJ5ID0geGVuX21jZWxvZy5uZXh0OworCisJLyoK
KwkgKiBXaGVuIHRoZSBidWZmZXIgZmlsbHMgdXAgZGlzY2FyZCBuZXcgZW50cmllcy4KKwkgKiBB
c3N1bWUgdGhhdCB0aGUgZWFybGllciBlcnJvcnMgYXJlIHRoZSBtb3JlCisJICogaW50ZXJlc3Rp
bmcgb25lczoKKwkgKi8KKwlpZiAoZW50cnkgPj0gWEVOX01DRV9MT0dfTEVOKSB7CisJCXNldF9i
aXQoWEVOX01DRV9PVkVSRkxPVywKKwkJCSh1bnNpZ25lZCBsb25nICopJnhlbl9tY2Vsb2cuZmxh
Z3MpOworCQlyZXR1cm47CisJfQorCisJbWVtY3B5KHhlbl9tY2Vsb2cuZW50cnkgKyBlbnRyeSwg
bWNlLCBzaXplb2Yoc3RydWN0IHhlbl9tY2UpKTsKKworCXhlbl9tY2Vsb2cubmV4dCsrOworfQor
CitzdGF0aWMgaW50IGNvbnZlcnRfbG9nKHN0cnVjdCBtY19pbmZvICptaSkKK3sKKwlzdHJ1Y3Qg
bWNpbmZvX2NvbW1vbiAqbWljOworCXN0cnVjdCBtY2luZm9fZ2xvYmFsICptY19nbG9iYWw7CisJ
c3RydWN0IG1jaW5mb19iYW5rICptY19iYW5rOworCXN0cnVjdCB4ZW5fbWNlIG07CisJdWludDMy
X3QgaTsKKworCW1pYyA9IE5VTEw7CisJeDg2X21jaW5mb19sb29rdXAoJm1pYywgbWksIE1DX1RZ
UEVfR0xPQkFMKTsKKwlpZiAodW5saWtlbHkoIW1pYykpIHsKKwkJcHJfd2FybmluZyhYRU5fTUNF
TE9HICJGYWlsZWQgdG8gZmluZCBnbG9iYWwgZXJyb3IgaW5mb1xuIik7CisJCXJldHVybiAtRU5P
REVWOworCX0KKworCW1lbXNldCgmbSwgMCwgc2l6ZW9mKHN0cnVjdCB4ZW5fbWNlKSk7CisKKwlt
Y19nbG9iYWwgPSAoc3RydWN0IG1jaW5mb19nbG9iYWwgKiltaWM7CisJbS5tY2dzdGF0dXMgPSBt
Y19nbG9iYWwtPm1jX2dzdGF0dXM7CisJbS5hcGljaWQgPSBtY19nbG9iYWwtPm1jX2FwaWNpZDsK
KworCWZvciAoaSA9IDA7IGkgPCBuY3B1czsgaSsrKQorCQlpZiAoZ19waHlzaW5mb1tpXS5tY19h
cGljaWQgPT0gbS5hcGljaWQpCisJCQlicmVhazsKKwlpZiAodW5saWtlbHkoaSA9PSBuY3B1cykp
IHsKKwkJcHJfd2FybmluZyhYRU5fTUNFTE9HICJGYWlsZWQgdG8gbWF0Y2ggY3B1IHdpdGggYXBp
Y2lkICVkXG4iLAorCQkJICAgbS5hcGljaWQpOworCQlyZXR1cm4gLUVOT0RFVjsKKwl9CisKKwlt
LnNvY2tldGlkID0gZ19waHlzaW5mb1tpXS5tY19jaGlwaWQ7CisJbS5jcHUgPSBtLmV4dGNwdSA9
IGdfcGh5c2luZm9baV0ubWNfY3B1bnI7CisJbS5jcHV2ZW5kb3IgPSAoX191OClnX3BoeXNpbmZv
W2ldLm1jX3ZlbmRvcjsKKwltLm1jZ2NhcCA9IGdfcGh5c2luZm9baV0ubWNfbXNydmFsdWVzW19f
TUNfTVNSX01DR0NBUF0udmFsdWU7CisKKwltaWMgPSBOVUxMOworCXg4Nl9tY2luZm9fbG9va3Vw
KCZtaWMsIG1pLCBNQ19UWVBFX0JBTkspOworCWlmICh1bmxpa2VseSghbWljKSkgeworCQlwcl93
YXJuaW5nKFhFTl9NQ0VMT0cgIkZhaWwgdG8gZmluZCBiYW5rIGVycm9yIGluZm9cbiIpOworCQly
ZXR1cm4gLUVOT0RFVjsKKwl9CisKKwlkbyB7CisJCWlmICgoIW1pYykgfHwgKG1pYy0+c2l6ZSA9
PSAwKSB8fAorCQkgICAgKG1pYy0+dHlwZSAhPSBNQ19UWVBFX0dMT0JBTCAgICYmCisJCSAgICAg
bWljLT50eXBlICE9IE1DX1RZUEVfQkFOSyAgICAgJiYKKwkJICAgICBtaWMtPnR5cGUgIT0gTUNf
VFlQRV9FWFRFTkRFRCAmJgorCQkgICAgIG1pYy0+dHlwZSAhPSBNQ19UWVBFX1JFQ09WRVJZKSkK
KwkJCWJyZWFrOworCisJCWlmIChtaWMtPnR5cGUgPT0gTUNfVFlQRV9CQU5LKSB7CisJCQltY19i
YW5rID0gKHN0cnVjdCBtY2luZm9fYmFuayAqKW1pYzsKKwkJCW0ubWlzYyA9IG1jX2JhbmstPm1j
X21pc2M7CisJCQltLnN0YXR1cyA9IG1jX2JhbmstPm1jX3N0YXR1czsKKwkJCW0uYWRkciA9IG1j
X2JhbmstPm1jX2FkZHI7CisJCQltLnRzYyA9IG1jX2JhbmstPm1jX3RzYzsKKwkJCW0uYmFuayA9
IG1jX2JhbmstPm1jX2Jhbms7CisJCQltLmZpbmlzaGVkID0gMTsKKwkJCS8qbG9nIHRoaXMgcmVj
b3JkKi8KKwkJCXhlbl9tY2VfbG9nKCZtKTsKKwkJfQorCQltaWMgPSB4ODZfbWNpbmZvX25leHQo
bWljKTsKKwl9IHdoaWxlICgxKTsKKworCXJldHVybiAwOworfQorCitzdGF0aWMgaW50IG1jX3F1
ZXVlX2hhbmRsZSh1aW50MzJfdCBmbGFncykKK3sKKwlzdHJ1Y3QgeGVuX21jIG1jX29wOworCWlu
dCByZXQgPSAwOworCisJbWNfb3AuY21kID0gWEVOX01DX2ZldGNoOworCW1jX29wLmludGVyZmFj
ZV92ZXJzaW9uID0gWEVOX01DQV9JTlRFUkZBQ0VfVkVSU0lPTjsKKwlzZXRfeGVuX2d1ZXN0X2hh
bmRsZShtY19vcC51Lm1jX2ZldGNoLmRhdGEsICZnX21pKTsKKwlkbyB7CisJCW1jX29wLnUubWNf
ZmV0Y2guZmxhZ3MgPSBmbGFnczsKKwkJcmV0ID0gSFlQRVJWSVNPUl9tY2EoJm1jX29wKTsKKwkJ
aWYgKHJldCkgeworCQkJcHJfZXJyKFhFTl9NQ0VMT0cgIkZhaWxlZCB0byBmZXRjaCAlcyBlcnJv
ciBsb2dcbiIsCisJCQkgICAgICAgKGZsYWdzID09IFhFTl9NQ19VUkdFTlQpID8KKwkJCSAgICAg
ICAidXJnbmV0IiA6ICJub251cmdlbnQiKTsKKwkJCWJyZWFrOworCQl9CisKKwkJaWYgKG1jX29w
LnUubWNfZmV0Y2guZmxhZ3MgJiBYRU5fTUNfTk9EQVRBIHx8CisJCSAgICBtY19vcC51Lm1jX2Zl
dGNoLmZsYWdzICYgWEVOX01DX0ZFVENIRkFJTEVEKQorCQkJYnJlYWs7CisJCWVsc2UgeworCQkJ
cmV0ID0gY29udmVydF9sb2coJmdfbWkpOworCQkJaWYgKHJldCkKKwkJCQlwcl93YXJuaW5nKFhF
Tl9NQ0VMT0cKKwkJCQkJICAgIkZhaWxlZCB0byBjb252ZXJ0IHRoaXMgZXJyb3IgbG9nLCAiCisJ
CQkJCSAgICJjb250aW51ZSBhY2tpbmcgaXQgYW55d2F5XG4iKTsKKworCQkJbWNfb3AudS5tY19m
ZXRjaC5mbGFncyA9IGZsYWdzIHwgWEVOX01DX0FDSzsKKwkJCXJldCA9IEhZUEVSVklTT1JfbWNh
KCZtY19vcCk7CisJCQlpZiAocmV0KSB7CisJCQkJcHJfZXJyKFhFTl9NQ0VMT0cKKwkJCQkgICAg
ICAgIkZhaWxlZCB0byBhY2sgcHJldmlvdXMgZXJyb3IgbG9nXG4iKTsKKwkJCQlicmVhazsKKwkJ
CX0KKwkJfQorCX0gd2hpbGUgKDEpOworCisJcmV0dXJuIHJldDsKK30KKworLyogdmlycSBoYW5k
bGVyIGZvciBtYWNoaW5lIGNoZWNrIGVycm9yIGluZm8qLworc3RhdGljIGlycXJldHVybl90IHhl
bl9tY2VfaW50ZXJydXB0KGludCBpcnEsIHZvaWQgKmRldl9pZCkKK3sKKwlpbnQgZXJyOworCXVu
c2lnbmVkIGxvbmcgdG1wOworCisJc3Bpbl9sb2NrX2lycXNhdmUoJm1jZWxvZ19sb2NrLCB0bXAp
OworCisJLyogdXJnZW50IG1jX2luZm8gKi8KKwllcnIgPSBtY19xdWV1ZV9oYW5kbGUoWEVOX01D
X1VSR0VOVCk7CisJaWYgKGVycikKKwkJcHJfZXJyKFhFTl9NQ0VMT0cKKwkJICAgICAgICJGYWls
ZWQgdG8gaGFuZGxlIHVyZ2VudCBtY19pbmZvIHF1ZXVlLCAiCisJCSAgICAgICAiY29udGludWUg
aGFuZGxpbmcgbm9udXJnZW50IG1jX2luZm8gcXVldWUgYW55d2F5LlxuIik7CisKKwkvKiBub251
cmdlbnQgbWNfaW5mbyAqLworCWVyciA9IG1jX3F1ZXVlX2hhbmRsZShYRU5fTUNfTk9OVVJHRU5U
KTsKKwlpZiAoZXJyKQorCQlwcl9lcnIoWEVOX01DRUxPRworCQkgICAgICAgIkZhaWxlZCB0byBo
YW5kbGUgbm9udXJnZW50IG1jX2luZm8gcXVldWUuXG4iKTsKKworCXNwaW5fdW5sb2NrX2lycXJl
c3RvcmUoJm1jZWxvZ19sb2NrLCB0bXApOworCisJcmV0dXJuIElSUV9IQU5ETEVEOworfQorCitz
dGF0aWMgaW50IGJpbmRfdmlycV9mb3JfbWNlKHZvaWQpCit7CisJaW50IHJldDsKKwlzdHJ1Y3Qg
eGVuX21jIG1jX29wOworCisJbWVtc2V0KCZtY19vcCwgMCwgc2l6ZW9mKHN0cnVjdCB4ZW5fbWMp
KTsKKworCS8qIEZldGNoIHBoeXNpY2FsIENQVSBOdW1iZXJzICovCisJbWNfb3AuY21kID0gWEVO
X01DX3BoeXNjcHVpbmZvOworCW1jX29wLmludGVyZmFjZV92ZXJzaW9uID0gWEVOX01DQV9JTlRF
UkZBQ0VfVkVSU0lPTjsKKwlzZXRfeGVuX2d1ZXN0X2hhbmRsZShtY19vcC51Lm1jX3BoeXNjcHVp
bmZvLmluZm8sIGdfcGh5c2luZm8pOworCXJldCA9IEhZUEVSVklTT1JfbWNhKCZtY19vcCk7CisJ
aWYgKHJldCkgeworCQlwcl9lcnIoWEVOX01DRUxPRyAiRmFpbGVkIHRvIGdldCBDUFUgbnVtYmVy
c1xuIik7CisJCXJldHVybiByZXQ7CisJfQorCisJLyogRmV0Y2ggZWFjaCBDUFUgUGh5c2ljYWwg
SW5mbyBmb3IgbGF0ZXIgcmVmZXJlbmNlKi8KKwluY3B1cyA9IG1jX29wLnUubWNfcGh5c2NwdWlu
Zm8ubmNwdXM7CisJZ19waHlzaW5mbyA9IGtjYWxsb2MobmNwdXMsIHNpemVvZihzdHJ1Y3QgbWNp
bmZvX2xvZ2ljYWxfY3B1KSwKKwkJCSAgICAgR0ZQX0tFUk5FTCk7CisJaWYgKCFnX3BoeXNpbmZv
KQorCQlyZXR1cm4gLUVOT01FTTsKKwlzZXRfeGVuX2d1ZXN0X2hhbmRsZShtY19vcC51Lm1jX3Bo
eXNjcHVpbmZvLmluZm8sIGdfcGh5c2luZm8pOworCXJldCA9IEhZUEVSVklTT1JfbWNhKCZtY19v
cCk7CisJaWYgKHJldCkgeworCQlwcl9lcnIoWEVOX01DRUxPRyAiRmFpbGVkIHRvIGdldCBDUFUg
aW5mb1xuIik7CisJCWtmcmVlKGdfcGh5c2luZm8pOworCQlyZXR1cm4gcmV0OworCX0KKworCXJl
dCAgPSBiaW5kX3ZpcnFfdG9faXJxaGFuZGxlcihWSVJRX01DQSwgMCwKKwkJCQkgICAgICAgeGVu
X21jZV9pbnRlcnJ1cHQsIDAsICJtY2UiLCBOVUxMKTsKKwlpZiAocmV0IDwgMCkgeworCQlwcl9l
cnIoWEVOX01DRUxPRyAiRmFpbGVkIHRvIGJpbmQgdmlycVxuIik7CisJCWtmcmVlKGdfcGh5c2lu
Zm8pOworCQlyZXR1cm4gcmV0OworCX0KKworCXJldHVybiAwOworfQorCit2b2lkIF9faW5pdCB4
ZW5fZWFybHlfaW5pdF9tY2Vsb2codm9pZCkKK3sKKwkvKiBPbmx5IERPTTAgaXMgcmVzcG9uc2li
bGUgZm9yIE1DRSBsb2dnaW5nICovCisJaWYgKHhlbl9pbml0aWFsX2RvbWFpbigpKQorCQltY2Vf
Y2hyZGV2X2RldmljZSA9IHhlbl9tY2VfY2hyZGV2X2RldmljZTsKK30KKworc3RhdGljIGludCBf
X2luaXQgeGVuX2xhdGVfaW5pdF9tY2Vsb2codm9pZCkKK3sKKwkvKiBPbmx5IERPTTAgaXMgcmVz
cG9uc2libGUgZm9yIE1DRSBsb2dnaW5nICovCisJaWYgKHhlbl9pbml0aWFsX2RvbWFpbigpKQor
CQlyZXR1cm4gYmluZF92aXJxX2Zvcl9tY2UoKTsKKworCXJldHVybiAtRU5PREVWOworfQorbGF0
ZV9pbml0Y2FsbCh4ZW5fbGF0ZV9pbml0X21jZWxvZyk7CmRpZmYgLS1naXQgYS9pbmNsdWRlL2xp
bnV4L21pc2NkZXZpY2UuaCBiL2luY2x1ZGUvbGludXgvbWlzY2RldmljZS5oCmluZGV4IDA1NDlk
MjEuLmUwZGVlYjIgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvbWlzY2RldmljZS5oCisrKyBi
L2luY2x1ZGUvbGludXgvbWlzY2RldmljZS5oCkBAIC0zNSw2ICszNSw3IEBACiAjZGVmaW5lIE1Q
VF9NSU5PUgkJMjIwCiAjZGVmaW5lIE1QVDJTQVNfTUlOT1IJCTIyMQogI2RlZmluZSBVSU5QVVRf
TUlOT1IJCTIyMworI2RlZmluZSBNSVNDX01DRUxPR19NSU5PUgkyMjcKICNkZWZpbmUgSFBFVF9N
SU5PUgkJMjI4CiAjZGVmaW5lIEZVU0VfTUlOT1IJCTIyOQogI2RlZmluZSBLVk1fTUlOT1IJCTIz
MgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3hlbi1tY2EuaCBiL2luY2x1ZGUv
eGVuL2ludGVyZmFjZS94ZW4tbWNhLmgKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAw
MC4uZjZlNGZlZgotLS0gL2Rldi9udWxsCisrKyBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS94ZW4t
bWNhLmgKQEAgLTAsMCArMSwzODkgQEAKKy8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKKyAqIGFyY2gt
eDg2L21jYS5oCisgKiBHdWVzdCBPUyBtYWNoaW5lIGNoZWNrIGludGVyZmFjZSB0byB4ODYgWGVu
LgorICoKKyAqIENvbnRyaWJ1dGVkIGJ5IEFkdmFuY2VkIE1pY3JvIERldmljZXMsIEluYy4KKyAq
IEF1dGhvcjogQ2hyaXN0b3BoIEVnZ2VyIDxDaHJpc3RvcGguRWdnZXJAYW1kLmNvbT4KKyAqCisg
KiBVcGRhdGVkIGJ5IEludGVsIENvcnBvcmF0aW9uCisgKiBBdXRob3I6IExpdSwgSmluc29uZyA8
amluc29uZy5saXVAaW50ZWwuY29tPgorICoKKyAqIFBlcm1pc3Npb24gaXMgaGVyZWJ5IGdyYW50
ZWQsIGZyZWUgb2YgY2hhcmdlLCB0byBhbnkgcGVyc29uIG9idGFpbmluZyBhIGNvcHkKKyAqIG9m
IHRoaXMgc29mdHdhcmUgYW5kIGFzc29jaWF0ZWQgZG9jdW1lbnRhdGlvbiBmaWxlcyAodGhlICJT
b2Z0d2FyZSIpLCB0bworICogZGVhbCBpbiB0aGUgU29mdHdhcmUgd2l0aG91dCByZXN0cmljdGlv
biwgaW5jbHVkaW5nIHdpdGhvdXQgbGltaXRhdGlvbiB0aGUKKyAqIHJpZ2h0cyB0byB1c2UsIGNv
cHksIG1vZGlmeSwgbWVyZ2UsIHB1Ymxpc2gsIGRpc3RyaWJ1dGUsIHN1YmxpY2Vuc2UsIGFuZC9v
cgorICogc2VsbCBjb3BpZXMgb2YgdGhlIFNvZnR3YXJlLCBhbmQgdG8gcGVybWl0IHBlcnNvbnMg
dG8gd2hvbSB0aGUgU29mdHdhcmUgaXMKKyAqIGZ1cm5pc2hlZCB0byBkbyBzbywgc3ViamVjdCB0
byB0aGUgZm9sbG93aW5nIGNvbmRpdGlvbnM6CisgKgorICogVGhlIGFib3ZlIGNvcHlyaWdodCBu
b3RpY2UgYW5kIHRoaXMgcGVybWlzc2lvbiBub3RpY2Ugc2hhbGwgYmUgaW5jbHVkZWQgaW4KKyAq
IGFsbCBjb3BpZXMgb3Igc3Vic3RhbnRpYWwgcG9ydGlvbnMgb2YgdGhlIFNvZnR3YXJlLgorICoK
KyAqIFRIRSBTT0ZUV0FSRSBJUyBQUk9WSURFRCAiQVMgSVMiLCBXSVRIT1VUIFdBUlJBTlRZIE9G
IEFOWSBLSU5ELCBFWFBSRVNTIE9SCisgKiBJTVBMSUVELCBJTkNMVURJTkcgQlVUIE5PVCBMSU1J
VEVEIFRPIFRIRSBXQVJSQU5USUVTIE9GIE1FUkNIQU5UQUJJTElUWSwKKyAqIEZJVE5FU1MgRk9S
IEEgUEFSVElDVUxBUiBQVVJQT1NFIEFORCBOT05JTkZSSU5HRU1FTlQuIElOIE5PIEVWRU5UIFNI
QUxMIFRIRQorICogQVVUSE9SUyBPUiBDT1BZUklHSFQgSE9MREVSUyBCRSBMSUFCTEUgRk9SIEFO
WSBDTEFJTSwgREFNQUdFUyBPUiBPVEhFUgorICogTElBQklMSVRZLCBXSEVUSEVSIElOIEFOIEFD
VElPTiBPRiBDT05UUkFDVCwgVE9SVCBPUiBPVEhFUldJU0UsIEFSSVNJTkcKKyAqIEZST00sIE9V
VCBPRiBPUiBJTiBDT05ORUNUSU9OIFdJVEggVEhFIFNPRlRXQVJFIE9SIFRIRSBVU0UgT1IgT1RI
RVIKKyAqIERFQUxJTkdTIElOIFRIRSBTT0ZUV0FSRS4KKyAqLworCisjaWZuZGVmIF9fWEVOX1BV
QkxJQ19BUkNIX1g4Nl9NQ0FfSF9fCisjZGVmaW5lIF9fWEVOX1BVQkxJQ19BUkNIX1g4Nl9NQ0Ff
SF9fCisKKy8qIEh5cGVyY2FsbCAqLworI2RlZmluZSBfX0hZUEVSVklTT1JfbWNhIF9fSFlQRVJW
SVNPUl9hcmNoXzAKKworI2RlZmluZSBYRU5fTUNBX0lOVEVSRkFDRV9WRVJTSU9OCTB4MDFlY2Mw
MDMKKworLyogSU46IERvbTAgY2FsbHMgaHlwZXJjYWxsIHRvIHJldHJpZXZlIG5vbnVyZ2VudCBl
cnJvciBsb2cgZW50cnkgKi8KKyNkZWZpbmUgWEVOX01DX05PTlVSR0VOVAkweDEKKy8qIElOOiBE
b20wIGNhbGxzIGh5cGVyY2FsbCB0byByZXRyaWV2ZSB1cmdlbnQgZXJyb3IgbG9nIGVudHJ5ICov
CisjZGVmaW5lIFhFTl9NQ19VUkdFTlQJCTB4MgorLyogSU46IERvbTAgYWNrbm93bGVkZ2VzIHBy
ZXZpb3NseS1mZXRjaGVkIGVycm9yIGxvZyBlbnRyeSAqLworI2RlZmluZSBYRU5fTUNfQUNLCQkw
eDQKKworLyogT1VUOiBBbGwgaXMgb2sgKi8KKyNkZWZpbmUgWEVOX01DX09LCQkweDAKKy8qIE9V
VDogRG9tYWluIGNvdWxkIG5vdCBmZXRjaCBkYXRhLiAqLworI2RlZmluZSBYRU5fTUNfRkVUQ0hG
QUlMRUQJMHgxCisvKiBPVVQ6IFRoZXJlIHdhcyBubyBtYWNoaW5lIGNoZWNrIGRhdGEgdG8gZmV0
Y2guICovCisjZGVmaW5lIFhFTl9NQ19OT0RBVEEJCTB4MgorCisjaWZuZGVmIF9fQVNTRU1CTFlf
XworLyogdklSUSBpbmplY3RlZCB0byBEb20wICovCisjZGVmaW5lIFZJUlFfTUNBIFZJUlFfQVJD
SF8wCisKKy8qCisgKiBtY19pbmZvIGVudHJ5IHR5cGVzCisgKiBtY2EgbWFjaGluZSBjaGVjayBp
bmZvIGFyZSByZWNvcmRlZCBpbiBtY19pbmZvIGVudHJpZXMuCisgKiB3aGVuIGZldGNoIG1jYSBp
bmZvLCBpdCBjYW4gdXNlIE1DX1RZUEVfLi4uIHRvIGRpc3Rpbmd1aXNoCisgKiBkaWZmZXJlbnQg
bWNhIGluZm8uCisgKi8KKyNkZWZpbmUgTUNfVFlQRV9HTE9CQUwJCTAKKyNkZWZpbmUgTUNfVFlQ
RV9CQU5LCQkxCisjZGVmaW5lIE1DX1RZUEVfRVhURU5ERUQJMgorI2RlZmluZSBNQ19UWVBFX1JF
Q09WRVJZCTMKKworc3RydWN0IG1jaW5mb19jb21tb24geworCXVpbnQxNl90IHR5cGU7IC8qIHN0
cnVjdHVyZSB0eXBlICovCisJdWludDE2X3Qgc2l6ZTsgLyogc2l6ZSBvZiB0aGlzIHN0cnVjdCBp
biBieXRlcyAqLworfTsKKworI2RlZmluZSBNQ19GTEFHX0NPUlJFQ1RBQkxFCSgxIDw8IDApCisj
ZGVmaW5lIE1DX0ZMQUdfVU5DT1JSRUNUQUJMRQkoMSA8PCAxKQorI2RlZmluZSBNQ19GTEFHX1JF
Q09WRVJBQkxFCSgxIDw8IDIpCisjZGVmaW5lIE1DX0ZMQUdfUE9MTEVECQkoMSA8PCAzKQorI2Rl
ZmluZSBNQ19GTEFHX1JFU0VUCQkoMSA8PCA0KQorI2RlZmluZSBNQ19GTEFHX0NNQ0kJCSgxIDw8
IDUpCisjZGVmaW5lIE1DX0ZMQUdfTUNFCQkoMSA8PCA2KQorCisvKiBjb250YWlucyB4ODYgZ2xv
YmFsIG1jIGluZm9ybWF0aW9uICovCitzdHJ1Y3QgbWNpbmZvX2dsb2JhbCB7CisJc3RydWN0IG1j
aW5mb19jb21tb24gY29tbW9uOworCisJdWludDE2X3QgbWNfZG9taWQ7IC8qIHJ1bm5pbmcgZG9t
YWluIGF0IHRoZSB0aW1lIGluIGVycm9yICovCisJdWludDE2X3QgbWNfdmNwdWlkOyAvKiB2aXJ0
dWFsIGNwdSBzY2hlZHVsZWQgZm9yIG1jX2RvbWlkICovCisJdWludDMyX3QgbWNfc29ja2V0aWQ7
IC8qIHBoeXNpY2FsIHNvY2tldCBvZiB0aGUgcGh5c2ljYWwgY29yZSAqLworCXVpbnQxNl90IG1j
X2NvcmVpZDsgLyogcGh5c2ljYWwgaW1wYWN0ZWQgY29yZSAqLworCXVpbnQxNl90IG1jX2NvcmVf
dGhyZWFkaWQ7IC8qIGNvcmUgdGhyZWFkIG9mIHBoeXNpY2FsIGNvcmUgKi8KKwl1aW50MzJfdCBt
Y19hcGljaWQ7CisJdWludDMyX3QgbWNfZmxhZ3M7CisJdWludDY0X3QgbWNfZ3N0YXR1czsgLyog
Z2xvYmFsIHN0YXR1cyAqLworfTsKKworLyogY29udGFpbnMgeDg2IGJhbmsgbWMgaW5mb3JtYXRp
b24gKi8KK3N0cnVjdCBtY2luZm9fYmFuayB7CisJc3RydWN0IG1jaW5mb19jb21tb24gY29tbW9u
OworCisJdWludDE2X3QgbWNfYmFuazsgLyogYmFuayBuciAqLworCXVpbnQxNl90IG1jX2RvbWlk
OyAvKiBkb21haW4gcmVmZXJlbmNlZCBieSBtY19hZGRyIGlmIHZhbGlkICovCisJdWludDY0X3Qg
bWNfc3RhdHVzOyAvKiBiYW5rIHN0YXR1cyAqLworCXVpbnQ2NF90IG1jX2FkZHI7IC8qIGJhbmsg
YWRkcmVzcyAqLworCXVpbnQ2NF90IG1jX21pc2M7CisJdWludDY0X3QgbWNfY3RybDI7CisJdWlu
dDY0X3QgbWNfdHNjOworfTsKKworc3RydWN0IG1jaW5mb19tc3IgeworCXVpbnQ2NF90IHJlZzsg
LyogTVNSICovCisJdWludDY0X3QgdmFsdWU7IC8qIE1TUiB2YWx1ZSAqLworfTsKKworLyogY29u
dGFpbnMgbWMgaW5mb3JtYXRpb24gZnJvbSBvdGhlciBvciBhZGRpdGlvbmFsIG1jIE1TUnMgKi8K
K3N0cnVjdCBtY2luZm9fZXh0ZW5kZWQgeworCXN0cnVjdCBtY2luZm9fY29tbW9uIGNvbW1vbjsK
Kwl1aW50MzJfdCBtY19tc3JzOyAvKiBOdW1iZXIgb2YgbXNyIHdpdGggdmFsaWQgdmFsdWVzLiAq
LworCS8qCisJICogQ3VycmVudGx5IEludGVsIGV4dGVuZGVkIE1TUiAoMzIvNjQpIGluY2x1ZGUg
YWxsIGdwIHJlZ2lzdGVycworCSAqIGFuZCBFKFIpRkxBR1MsIEUoUilJUCwgRShSKU1JU0MsIHVw
IHRvIDExLzE5IG9mIHRoZW0gbWlnaHQgYmUKKwkgKiB1c2VmdWwgYXQgcHJlc2VudC4gU28gZXhw
YW5kIHRoaXMgYXJyYXkgdG8gMTYvMzIgdG8gbGVhdmUgcm9vbS4KKwkgKi8KKwlzdHJ1Y3QgbWNp
bmZvX21zciBtY19tc3Jbc2l6ZW9mKHZvaWQgKikgKiA0XTsKK307CisKKy8qIFJlY292ZXJ5IEFj
dGlvbiBmbGFncy4gR2l2aW5nIHJlY292ZXJ5IHJlc3VsdCBpbmZvcm1hdGlvbiB0byBET00wICov
CisKKy8qIFhlbiB0YWtlcyBzdWNjZXNzZnVsIHJlY292ZXJ5IGFjdGlvbiwgdGhlIGVycm9yIGlz
IHJlY292ZXJlZCAqLworI2RlZmluZSBSRUNfQUNUSU9OX1JFQ09WRVJFRCAoMHgxIDw8IDApCisv
KiBObyBhY3Rpb24gaXMgcGVyZm9ybWVkIGJ5IFhFTiAqLworI2RlZmluZSBSRUNfQUNUSU9OX05P
TkUgKDB4MSA8PCAxKQorLyogSXQncyBwb3NzaWJsZSBET00wIG1pZ2h0IHRha2UgYWN0aW9uIG93
bmVyc2hpcCBpbiBzb21lIGNhc2UgKi8KKyNkZWZpbmUgUkVDX0FDVElPTl9ORUVEX1JFU0VUICgw
eDEgPDwgMikKKworLyoKKyAqIERpZmZlcmVudCBSZWNvdmVyeSBBY3Rpb24gdHlwZXMsIGlmIHRo
ZSBhY3Rpb24gaXMgcGVyZm9ybWVkIHN1Y2Nlc3NmdWxseSwKKyAqIFJFQ19BQ1RJT05fUkVDT1ZF
UkVEIGZsYWcgd2lsbCBiZSByZXR1cm5lZC4KKyAqLworCisvKiBQYWdlIE9mZmxpbmUgQWN0aW9u
ICovCisjZGVmaW5lIE1DX0FDVElPTl9QQUdFX09GRkxJTkUgKDB4MSA8PCAwKQorLyogQ1BVIG9m
ZmxpbmUgQWN0aW9uICovCisjZGVmaW5lIE1DX0FDVElPTl9DUFVfT0ZGTElORSAoMHgxIDw8IDEp
CisvKiBMMyBjYWNoZSBkaXNhYmxlIEFjdGlvbiAqLworI2RlZmluZSBNQ19BQ1RJT05fQ0FDSEVf
U0hSSU5LICgweDEgPDwgMikKKworLyoKKyAqIEJlbG93IGludGVyZmFjZSB1c2VkIGJldHdlZW4g
WEVOL0RPTTAgZm9yIHBhc3NpbmcgWEVOJ3MgcmVjb3ZlcnkgYWN0aW9uCisgKiBpbmZvcm1hdGlv
biB0byBET00wLgorICovCitzdHJ1Y3QgcGFnZV9vZmZsaW5lX2FjdGlvbiB7CisJLyogUGFyYW1z
IGZvciBwYXNzaW5nIHRoZSBvZmZsaW5lZCBwYWdlIG51bWJlciB0byBET00wICovCisJdWludDY0
X3QgbWZuOworCXVpbnQ2NF90IHN0YXR1czsKK307CisKK3N0cnVjdCBjcHVfb2ZmbGluZV9hY3Rp
b24geworCS8qIFBhcmFtcyBmb3IgcGFzc2luZyB0aGUgaWRlbnRpdHkgb2YgdGhlIG9mZmxpbmVk
IENQVSB0byBET00wICovCisJdWludDMyX3QgbWNfc29ja2V0aWQ7CisJdWludDE2X3QgbWNfY29y
ZWlkOworCXVpbnQxNl90IG1jX2NvcmVfdGhyZWFkaWQ7Cit9OworCisjZGVmaW5lIE1BWF9VTklP
Tl9TSVpFIDE2CitzdHJ1Y3QgbWNpbmZvX3JlY292ZXJ5IHsKKwlzdHJ1Y3QgbWNpbmZvX2NvbW1v
biBjb21tb247CisJdWludDE2X3QgbWNfYmFuazsgLyogYmFuayBuciAqLworCXVpbnQ4X3QgYWN0
aW9uX2ZsYWdzOworCXVpbnQ4X3QgYWN0aW9uX3R5cGVzOworCXVuaW9uIHsKKwkJc3RydWN0IHBh
Z2Vfb2ZmbGluZV9hY3Rpb24gcGFnZV9yZXRpcmU7CisJCXN0cnVjdCBjcHVfb2ZmbGluZV9hY3Rp
b24gY3B1X29mZmxpbmU7CisJCXVpbnQ4X3QgcGFkW01BWF9VTklPTl9TSVpFXTsKKwl9IGFjdGlv
bl9pbmZvOworfTsKKworCisjZGVmaW5lIE1DSU5GT19NQVhTSVpFIDc2OAorc3RydWN0IG1jX2lu
Zm8geworCS8qIE51bWJlciBvZiBtY2luZm9fKiBlbnRyaWVzIGluIG1pX2RhdGEgKi8KKwl1aW50
MzJfdCBtaV9uZW50cmllczsKKwl1aW50MzJfdCBmbGFnczsKKwl1aW50NjRfdCBtaV9kYXRhWyhN
Q0lORk9fTUFYU0laRSAtIDEpIC8gOF07Cit9OworREVGSU5FX0dVRVNUX0hBTkRMRV9TVFJVQ1Qo
bWNfaW5mbyk7CisKKyNkZWZpbmUgX19NQ19NU1JfQVJSQVlTSVpFIDgKKyNkZWZpbmUgX19NQ19N
U1JfTUNHQ0FQIDAKKyNkZWZpbmUgX19NQ19OTVNSUyAxCisjZGVmaW5lIE1DX05DQVBTIDcKK3N0
cnVjdCBtY2luZm9fbG9naWNhbF9jcHUgeworCXVpbnQzMl90IG1jX2NwdW5yOworCXVpbnQzMl90
IG1jX2NoaXBpZDsKKwl1aW50MTZfdCBtY19jb3JlaWQ7CisJdWludDE2X3QgbWNfdGhyZWFkaWQ7
CisJdWludDMyX3QgbWNfYXBpY2lkOworCXVpbnQzMl90IG1jX2NsdXN0ZXJpZDsKKwl1aW50MzJf
dCBtY19uY29yZXM7CisJdWludDMyX3QgbWNfbmNvcmVzX2FjdGl2ZTsKKwl1aW50MzJfdCBtY19u
dGhyZWFkczsKKwl1aW50MzJfdCBtY19jcHVpZF9sZXZlbDsKKwl1aW50MzJfdCBtY19mYW1pbHk7
CisJdWludDMyX3QgbWNfdmVuZG9yOworCXVpbnQzMl90IG1jX21vZGVsOworCXVpbnQzMl90IG1j
X3N0ZXA7CisJY2hhciBtY192ZW5kb3JpZFsxNl07CisJY2hhciBtY19icmFuZGlkWzY0XTsKKwl1
aW50MzJfdCBtY19jcHVfY2Fwc1tNQ19OQ0FQU107CisJdWludDMyX3QgbWNfY2FjaGVfc2l6ZTsK
Kwl1aW50MzJfdCBtY19jYWNoZV9hbGlnbm1lbnQ7CisJdWludDMyX3QgbWNfbm1zcnZhbHM7CisJ
c3RydWN0IG1jaW5mb19tc3IgbWNfbXNydmFsdWVzW19fTUNfTVNSX0FSUkFZU0laRV07Cit9Owor
REVGSU5FX0dVRVNUX0hBTkRMRV9TVFJVQ1QobWNpbmZvX2xvZ2ljYWxfY3B1KTsKKworLyoKKyAq
IFByb3RvdHlwZToKKyAqICAgIHVpbnQzMl90IHg4Nl9tY2luZm9fbmVudHJpZXMoc3RydWN0IG1j
X2luZm8gKm1pKTsKKyAqLworI2RlZmluZSB4ODZfbWNpbmZvX25lbnRyaWVzKF9taSkgICAgXAor
CSgoX21pKS0+bWlfbmVudHJpZXMpCisvKgorICogUHJvdG90eXBlOgorICogICAgc3RydWN0IG1j
aW5mb19jb21tb24gKng4Nl9tY2luZm9fZmlyc3Qoc3RydWN0IG1jX2luZm8gKm1pKTsKKyAqLwor
I2RlZmluZSB4ODZfbWNpbmZvX2ZpcnN0KF9taSkgICAgICAgXAorCSgoc3RydWN0IG1jaW5mb19j
b21tb24gKikoX21pKS0+bWlfZGF0YSkKKy8qCisgKiBQcm90b3R5cGU6CisgKiAgICBzdHJ1Y3Qg
bWNpbmZvX2NvbW1vbiAqeDg2X21jaW5mb19uZXh0KHN0cnVjdCBtY2luZm9fY29tbW9uICptaWMp
OworICovCisjZGVmaW5lIHg4Nl9tY2luZm9fbmV4dChfbWljKSAgICAgICBcCisJKChzdHJ1Y3Qg
bWNpbmZvX2NvbW1vbiAqKSgodWludDhfdCAqKShfbWljKSArIChfbWljKS0+c2l6ZSkpCisKKy8q
CisgKiBQcm90b3R5cGU6CisgKiAgICB2b2lkIHg4Nl9tY2luZm9fbG9va3VwKHZvaWQgKnJldCwg
c3RydWN0IG1jX2luZm8gKm1pLCB1aW50MTZfdCB0eXBlKTsKKyAqLworc3RhdGljIGlubGluZSB2
b2lkIHg4Nl9tY2luZm9fbG9va3VwKHN0cnVjdCBtY2luZm9fY29tbW9uICoqcmV0LAorCQkJCSAg
ICAgc3RydWN0IG1jX2luZm8gKm1pLCB1aW50MTZfdCB0eXBlKQoreworCXVpbnQzMl90IGk7CisJ
c3RydWN0IG1jaW5mb19jb21tb24gKm1pYzsKKwlib29sIGZvdW5kID0gMDsKKworCWlmICghcmV0
IHx8ICFtaSkKKwkJcmV0dXJuOworCisJbWljID0geDg2X21jaW5mb19maXJzdChtaSk7CisJZm9y
IChpID0gMDsgaSA8IHg4Nl9tY2luZm9fbmVudHJpZXMobWkpOyBpKyspIHsKKwkJaWYgKG1pYy0+
dHlwZSA9PSB0eXBlKSB7CisJCQlmb3VuZCA9IDE7CisJCQlicmVhazsKKwkJfQorCQltaWMgPSB4
ODZfbWNpbmZvX25leHQobWljKTsKKwl9CisKKwkqcmV0ID0gZm91bmQgPyBtaWMgOiBOVUxMOwor
fQorCisvKgorICogRmV0Y2ggbWFjaGluZSBjaGVjayBkYXRhIGZyb20gaHlwZXJ2aXNvci4KKyAq
LworI2RlZmluZSBYRU5fTUNfZmV0Y2gJCTEKK3N0cnVjdCB4ZW5fbWNfZmV0Y2ggeworCS8qCisJ
ICogSU46IFhFTl9NQ19OT05VUkdFTlQsIFhFTl9NQ19VUkdFTlQsCisJICogWEVOX01DX0FDSyBp
ZiBhY2sna2luZyBhbiBlYXJsaWVyIGZldGNoCisJICogT1VUOiBYRU5fTUNfT0ssIFhFTl9NQ19G
RVRDSEFJTEVELCBYRU5fTUNfTk9EQVRBCisJICovCisJdWludDMyX3QgZmxhZ3M7CisJdWludDMy
X3QgX3BhZDA7CisJLyogT1VUOiBpZCBmb3IgYWNrLCBJTjogaWQgd2UgYXJlIGFjaydpbmcgKi8K
Kwl1aW50NjRfdCBmZXRjaF9pZDsKKworCS8qIE9VVCB2YXJpYWJsZXMuICovCisJR1VFU1RfSEFO
RExFKG1jX2luZm8pIGRhdGE7Cit9OworREVGSU5FX0dVRVNUX0hBTkRMRV9TVFJVQ1QoeGVuX21j
X2ZldGNoKTsKKworCisvKgorICogVGhpcyB0ZWxscyB0aGUgaHlwZXJ2aXNvciB0byBub3RpZnkg
YSBEb21VIGFib3V0IHRoZSBtYWNoaW5lIGNoZWNrIGVycm9yCisgKi8KKyNkZWZpbmUgWEVOX01D
X25vdGlmeWRvbWFpbgkyCitzdHJ1Y3QgeGVuX21jX25vdGlmeWRvbWFpbiB7CisJLyogSU4gdmFy
aWFibGVzICovCisJdWludDE2X3QgbWNfZG9taWQ7IC8qIFRoZSB1bnByaXZpbGVnZWQgZG9tYWlu
IHRvIG5vdGlmeSAqLworCXVpbnQxNl90IG1jX3ZjcHVpZDsgLyogVGhlIHZjcHUgaW4gbWNfZG9t
aWQgdG8gbm90aWZ5ICovCisKKwkvKiBJTi9PVVQgdmFyaWFibGVzICovCisJdWludDMyX3QgZmxh
Z3M7Cit9OworREVGSU5FX0dVRVNUX0hBTkRMRV9TVFJVQ1QoeGVuX21jX25vdGlmeWRvbWFpbik7
CisKKyNkZWZpbmUgWEVOX01DX3BoeXNjcHVpbmZvCTMKK3N0cnVjdCB4ZW5fbWNfcGh5c2NwdWlu
Zm8geworCS8qIElOL09VVCAqLworCXVpbnQzMl90IG5jcHVzOworCXVpbnQzMl90IF9wYWQwOwor
CS8qIE9VVCAqLworCUdVRVNUX0hBTkRMRShtY2luZm9fbG9naWNhbF9jcHUpIGluZm87Cit9Owor
CisjZGVmaW5lIFhFTl9NQ19tc3JpbmplY3QJNAorI2RlZmluZSBNQ19NU1JJTkpfTUFYTVNSUwk4
CitzdHJ1Y3QgeGVuX21jX21zcmluamVjdCB7CisJLyogSU4gKi8KKwl1aW50MzJfdCBtY2lual9j
cHVucjsgLyogdGFyZ2V0IHByb2Nlc3NvciBpZCAqLworCXVpbnQzMl90IG1jaW5qX2ZsYWdzOyAv
KiBzZWUgTUNfTVNSSU5KX0ZfKiBiZWxvdyAqLworCXVpbnQzMl90IG1jaW5qX2NvdW50OyAvKiAw
IC4uIGNvdW50LTEgaW4gYXJyYXkgYXJlIHZhbGlkICovCisJdWludDMyX3QgX3BhZDA7CisJc3Ry
dWN0IG1jaW5mb19tc3IgbWNpbmpfbXNyW01DX01TUklOSl9NQVhNU1JTXTsKK307CisKKy8qIEZs
YWdzIGZvciBtY2lual9mbGFncyBhYm92ZTsgYml0cyAxNi0zMSBhcmUgcmVzZXJ2ZWQgKi8KKyNk
ZWZpbmUgTUNfTVNSSU5KX0ZfSU5URVJQT1NFCTB4MQorCisjZGVmaW5lIFhFTl9NQ19tY2Vpbmpl
Y3QJNQorc3RydWN0IHhlbl9tY19tY2VpbmplY3QgeworCXVuc2lnbmVkIGludCBtY2VpbmpfY3B1
bnI7IC8qIHRhcmdldCBwcm9jZXNzb3IgaWQgKi8KK307CisKK3N0cnVjdCB4ZW5fbWMgeworCXVp
bnQzMl90IGNtZDsKKwl1aW50MzJfdCBpbnRlcmZhY2VfdmVyc2lvbjsgLyogWEVOX01DQV9JTlRF
UkZBQ0VfVkVSU0lPTiAqLworCXVuaW9uIHsKKwkJc3RydWN0IHhlbl9tY19mZXRjaCAgICAgICAg
bWNfZmV0Y2g7CisJCXN0cnVjdCB4ZW5fbWNfbm90aWZ5ZG9tYWluIG1jX25vdGlmeWRvbWFpbjsK
KwkJc3RydWN0IHhlbl9tY19waHlzY3B1aW5mbyAgbWNfcGh5c2NwdWluZm87CisJCXN0cnVjdCB4
ZW5fbWNfbXNyaW5qZWN0ICAgIG1jX21zcmluamVjdDsKKwkJc3RydWN0IHhlbl9tY19tY2Vpbmpl
Y3QgICAgbWNfbWNlaW5qZWN0OworCX0gdTsKK307CitERUZJTkVfR1VFU1RfSEFORExFX1NUUlVD
VCh4ZW5fbWMpOworCitleHRlcm4gc3RydWN0IG1pc2NkZXZpY2UgbWNlX2NocmRldl9kZXZpY2U7
CisKK3ZvaWQgeGVuX2Vhcmx5X2luaXRfbWNlbG9nKHZvaWQpOworCisvKiBGaWVsZHMgYXJlIHpl
cm8gd2hlbiBub3QgYXZhaWxhYmxlICovCitzdHJ1Y3QgeGVuX21jZSB7CisJX191NjQgc3RhdHVz
OworCV9fdTY0IG1pc2M7CisJX191NjQgYWRkcjsKKwlfX3U2NCBtY2dzdGF0dXM7CisJX191NjQg
aXA7CisJX191NjQgdHNjOwkvKiBjcHUgdGltZSBzdGFtcCBjb3VudGVyICovCisJX191NjQgdGlt
ZTsJLyogd2FsbCB0aW1lX3Qgd2hlbiBlcnJvciB3YXMgZGV0ZWN0ZWQgKi8KKwlfX3U4ICBjcHV2
ZW5kb3I7CS8qIGNwdSB2ZW5kb3IgYXMgZW5jb2RlZCBpbiBzeXN0ZW0uaCAqLworCV9fdTggIGlu
amVjdF9mbGFnczsJLyogc29mdHdhcmUgaW5qZWN0IGZsYWdzICovCisJX191MTYgIHBhZDsKKwlf
X3UzMiBjcHVpZDsJLyogQ1BVSUQgMSBFQVggKi8KKwlfX3U4ICBjczsJCS8qIGNvZGUgc2VnbWVu
dCAqLworCV9fdTggIGJhbms7CS8qIG1hY2hpbmUgY2hlY2sgYmFuayAqLworCV9fdTggIGNwdTsJ
LyogY3B1IG51bWJlcjsgb2Jzb2xldGU7IHVzZSBleHRjcHUgbm93ICovCisJX191OCAgZmluaXNo
ZWQ7ICAgLyogZW50cnkgaXMgdmFsaWQgKi8KKwlfX3UzMiBleHRjcHU7CS8qIGxpbnV4IGNwdSBu
dW1iZXIgdGhhdCBkZXRlY3RlZCB0aGUgZXJyb3IgKi8KKwlfX3UzMiBzb2NrZXRpZDsJLyogQ1BV
IHNvY2tldCBJRCAqLworCV9fdTMyIGFwaWNpZDsJLyogQ1BVIGluaXRpYWwgYXBpYyBJRCAqLwor
CV9fdTY0IG1jZ2NhcDsJLyogTUNHQ0FQIE1TUjogbWFjaGluZSBjaGVjayBjYXBhYmlsaXRpZXMg
b2YgQ1BVICovCit9OworCisvKgorICogVGhpcyBzdHJ1Y3R1cmUgY29udGFpbnMgYWxsIGRhdGEg
cmVsYXRlZCB0byB0aGUgTUNFIGxvZy4gIEFsc28KKyAqIGNhcnJpZXMgYSBzaWduYXR1cmUgdG8g
bWFrZSBpdCBlYXNpZXIgdG8gZmluZCBmcm9tIGV4dGVybmFsCisgKiBkZWJ1Z2dpbmcgdG9vbHMu
ICBFYWNoIGVudHJ5IGlzIG9ubHkgdmFsaWQgd2hlbiBpdHMgZmluaXNoZWQgZmxhZworICogaXMg
c2V0LgorICovCisKKyNkZWZpbmUgWEVOX01DRV9MT0dfTEVOIDMyCisKK3N0cnVjdCB4ZW5fbWNl
X2xvZyB7CisJY2hhciBzaWduYXR1cmVbMTJdOyAvKiAiTUFDSElORUNIRUNLIiAqLworCXVuc2ln
bmVkIGxlbjsJICAgIC8qID0gWEVOX01DRV9MT0dfTEVOICovCisJdW5zaWduZWQgbmV4dDsKKwl1
bnNpZ25lZCBmbGFnczsKKwl1bnNpZ25lZCByZWNvcmRsZW47CS8qIGxlbmd0aCBvZiBzdHJ1Y3Qg
eGVuX21jZSAqLworCXN0cnVjdCB4ZW5fbWNlIGVudHJ5W1hFTl9NQ0VfTE9HX0xFTl07Cit9Owor
CisjZGVmaW5lIFhFTl9NQ0VfT1ZFUkZMT1cgMAkJLyogYml0IDAgaW4gZmxhZ3MgbWVhbnMgb3Zl
cmZsb3cgKi8KKworI2RlZmluZSBYRU5fTUNFX0xPR19TSUdOQVRVUkUJIk1BQ0hJTkVDSEVDSyIK
KworI2RlZmluZSBNQ0VfR0VUX1JFQ09SRF9MRU4gICBfSU9SKCdNJywgMSwgaW50KQorI2RlZmlu
ZSBNQ0VfR0VUX0xPR19MRU4gICAgICBfSU9SKCdNJywgMiwgaW50KQorI2RlZmluZSBNQ0VfR0VU
Q0xFQVJfRkxBR1MgICBfSU9SKCdNJywgMywgaW50KQorCisjZW5kaWYgLyogX19BU1NFTUJMWV9f
ICovCisjZW5kaWYgLyogX19YRU5fUFVCTElDX0FSQ0hfWDg2X01DQV9IX18gKi8KLS0gCjEuNy4x
Cgo=

--_002_DE8DF0795D48FD4CA783C40EC82923351D6892SHSMSX101ccrcorpi_--
