Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab2EaM57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 08:57:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:62901 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab2EaM55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 08:57:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="149923341"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] xen/mce: Add mcelog support for Xen platform
Thread-Topic: [PATCH 1/2] xen/mce: Add mcelog support for Xen platform
Thread-Index: Ac0/LPhJ2qSMzi1PTzSzWPGw5NRHtw==
Date: Thu, 31 May 2012 12:57:44 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351FEE7C@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923351FEE7CSHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923351FEE7CSHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 1a7951d6ca01d7f2c9dd2bdb6de5f8e7fdcb8bbd Mon Sep 17 00:00:00 2001
From: root <root@ljsromley.bj.intel.com>
Date: Fri, 1 Jun 2012 03:12:51 +0800
Subject: [PATCH 1/2] xen/mce: Add mcelog support for Xen platform

When MCA error occurs, it would be handled by Xen hypervisor first,
and then the error information would be sent to initial domain for logging.

This patch gets error information from Xen hypervisor and convert
Xen format error into Linux format mcelog. This logic is basically
self-contained, not touching other kernel components.

By using tools like mcelog tool users could read specific error information=
,
like what they did under native Linux.

To test follow directions outlined in Documentation/acpi/apei/einj.txt

Signed-off-by: Ke, Liping <liping.ke@intel.com>
Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 arch/x86/include/asm/xen/hypercall.h |    8 +
 arch/x86/kernel/cpu/mcheck/mce.c     |    4 +-
 arch/x86/xen/enlighten.c             |    5 +-
 drivers/xen/Kconfig                  |    8 +
 drivers/xen/Makefile                 |    1 +
 drivers/xen/mcelog.c                 |  392 ++++++++++++++++++++++++++++++=
++++
 include/linux/miscdevice.h           |    1 +
 include/xen/interface/xen-mca.h      |  385 ++++++++++++++++++++++++++++++=
+++
 8 files changed, 798 insertions(+), 6 deletions(-)
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
index b772dd6..5e5c863 100644
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
@@ -2341,7 +2339,7 @@ static __init int mcheck_init_device(void)
=20
 	return err;
 }
-device_initcall(mcheck_init_device);
+device_initcall_sync(mcheck_init_device);
=20
 /*
  * Old style boot options parsing. Only for compatibility.
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 75f33b2..ff2d00e 100644
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
@@ -333,9 +334,7 @@ static void __init xen_init_cpuid_mask(void)
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
index 8d2501e..d4dffcd 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -196,4 +196,12 @@ config XEN_ACPI_PROCESSOR
 	  called xen_acpi_processor  If you do not know what to choose, select
 	  M here. If the CPUFREQ drivers are built in, select Y here.
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
index fc34886..a787029 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_XEN_PVHVM)			+=3D platform-pci.o
 obj-$(CONFIG_XEN_TMEM)			+=3D tmem.o
 obj-$(CONFIG_SWIOTLB_XEN)		+=3D swiotlb-xen.o
 obj-$(CONFIG_XEN_DOM0)			+=3D pci.o acpi.o
+obj-$(CONFIG_XEN_MCE_LOG)		+=3D mcelog.o
 obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+=3D xen-pciback/
 obj-$(CONFIG_XEN_PRIVCMD)		+=3D xen-privcmd.o
 obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+=3D xen-acpi-processor.o
diff --git a/drivers/xen/mcelog.c b/drivers/xen/mcelog.c
new file mode 100644
index 0000000..72e87d2
--- /dev/null
+++ b/drivers/xen/mcelog.c
@@ -0,0 +1,392 @@
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
+static int __init xen_late_init_mcelog(void)
+{
+	/* Only DOM0 is responsible for MCE logging */
+	if (xen_initial_domain()) {
+		/* register character device /dev/mcelog for xen mcelog */
+		if (misc_register(&xen_mce_chrdev_device))
+			return -ENODEV;
+		return bind_virq_for_mce();
+	}
+
+	return -ENODEV;
+}
+device_initcall(xen_late_init_mcelog);
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
index 0000000..73a4ea7
--- /dev/null
+++ b/include/xen/interface/xen-mca.h
@@ -0,0 +1,385 @@
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

--_002_DE8DF0795D48FD4CA783C40EC82923351FEE7CSHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-xen-mce-Add-mcelog-support-for-Xen-platform.patch"
Content-Description: 0001-xen-mce-Add-mcelog-support-for-Xen-platform.patch
Content-Disposition: attachment;
	filename="0001-xen-mce-Add-mcelog-support-for-Xen-platform.patch";
	size=27069; creation-date="Thu, 31 May 2012 12:54:12 GMT";
	modification-date="Thu, 31 May 2012 20:49:24 GMT"
Content-Transfer-Encoding: base64

RnJvbSAxYTc5NTFkNmNhMDFkN2YyYzlkZDJiZGI2ZGU1ZjhlN2ZkY2I4YmJkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiByb290IDxyb290QGxqc3JvbWxleS5iai5pbnRlbC5jb20+CkRh
dGU6IEZyaSwgMSBKdW4gMjAxMiAwMzoxMjo1MSArMDgwMApTdWJqZWN0OiBbUEFUQ0ggMS8yXSB4
ZW4vbWNlOiBBZGQgbWNlbG9nIHN1cHBvcnQgZm9yIFhlbiBwbGF0Zm9ybQoKV2hlbiBNQ0EgZXJy
b3Igb2NjdXJzLCBpdCB3b3VsZCBiZSBoYW5kbGVkIGJ5IFhlbiBoeXBlcnZpc29yIGZpcnN0LAph
bmQgdGhlbiB0aGUgZXJyb3IgaW5mb3JtYXRpb24gd291bGQgYmUgc2VudCB0byBpbml0aWFsIGRv
bWFpbiBmb3IgbG9nZ2luZy4KClRoaXMgcGF0Y2ggZ2V0cyBlcnJvciBpbmZvcm1hdGlvbiBmcm9t
IFhlbiBoeXBlcnZpc29yIGFuZCBjb252ZXJ0ClhlbiBmb3JtYXQgZXJyb3IgaW50byBMaW51eCBm
b3JtYXQgbWNlbG9nLiBUaGlzIGxvZ2ljIGlzIGJhc2ljYWxseQpzZWxmLWNvbnRhaW5lZCwgbm90
IHRvdWNoaW5nIG90aGVyIGtlcm5lbCBjb21wb25lbnRzLgoKQnkgdXNpbmcgdG9vbHMgbGlrZSBt
Y2Vsb2cgdG9vbCB1c2VycyBjb3VsZCByZWFkIHNwZWNpZmljIGVycm9yIGluZm9ybWF0aW9uLAps
aWtlIHdoYXQgdGhleSBkaWQgdW5kZXIgbmF0aXZlIExpbnV4LgoKVG8gdGVzdCBmb2xsb3cgZGly
ZWN0aW9ucyBvdXRsaW5lZCBpbiBEb2N1bWVudGF0aW9uL2FjcGkvYXBlaS9laW5qLnR4dAoKU2ln
bmVkLW9mZi1ieTogS2UsIExpcGluZyA8bGlwaW5nLmtlQGludGVsLmNvbT4KU2lnbmVkLW9mZi1i
eTogSmlhbmcsIFl1bmhvbmcgPHl1bmhvbmcuamlhbmdAaW50ZWwuY29tPgpTaWduZWQtb2ZmLWJ5
OiBKZXJlbXkgRml0emhhcmRpbmdlIDxqZXJlbXkuZml0emhhcmRpbmdlQGNpdHJpeC5jb20+ClNp
Z25lZC1vZmYtYnk6IExpdSwgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgotLS0KIGFy
Y2gveDg2L2luY2x1ZGUvYXNtL3hlbi9oeXBlcmNhbGwuaCB8ICAgIDggKwogYXJjaC94ODYva2Vy
bmVsL2NwdS9tY2hlY2svbWNlLmMgICAgIHwgICAgNCArLQogYXJjaC94ODYveGVuL2VubGlnaHRl
bi5jICAgICAgICAgICAgIHwgICAgNSArLQogZHJpdmVycy94ZW4vS2NvbmZpZyAgICAgICAgICAg
ICAgICAgIHwgICAgOCArCiBkcml2ZXJzL3hlbi9NYWtlZmlsZSAgICAgICAgICAgICAgICAgfCAg
ICAxICsKIGRyaXZlcnMveGVuL21jZWxvZy5jICAgICAgICAgICAgICAgICB8ICAzOTIgKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKwogaW5jbHVkZS9saW51eC9taXNjZGV2aWNlLmgg
ICAgICAgICAgIHwgICAgMSArCiBpbmNsdWRlL3hlbi9pbnRlcmZhY2UveGVuLW1jYS5oICAgICAg
fCAgMzg1ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogOCBmaWxlcyBjaGFuZ2Vk
LCA3OTggaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKIGNyZWF0ZSBtb2RlIDEwMDY0NCBk
cml2ZXJzL3hlbi9tY2Vsb2cuYwogY3JlYXRlIG1vZGUgMTAwNjQ0IGluY2x1ZGUveGVuL2ludGVy
ZmFjZS94ZW4tbWNhLmgKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS94ZW4vaHlw
ZXJjYWxsLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS94ZW4vaHlwZXJjYWxsLmgKaW5kZXggNTcy
ODg1Mi4uNTljMjI2ZCAxMDA2NDQKLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20veGVuL2h5cGVy
Y2FsbC5oCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3hlbi9oeXBlcmNhbGwuaApAQCAtNDgs
NiArNDgsNyBAQAogI2luY2x1ZGUgPHhlbi9pbnRlcmZhY2Uvc2NoZWQuaD4KICNpbmNsdWRlIDx4
ZW4vaW50ZXJmYWNlL3BoeXNkZXYuaD4KICNpbmNsdWRlIDx4ZW4vaW50ZXJmYWNlL3BsYXRmb3Jt
Lmg+CisjaW5jbHVkZSA8eGVuL2ludGVyZmFjZS94ZW4tbWNhLmg+CiAKIC8qCiAgKiBUaGUgaHlw
ZXJjYWxsIGFzbXMgaGF2ZSB0byBtZWV0IHNldmVyYWwgY29uc3RyYWludHM6CkBAIC0zMDIsNiAr
MzAzLDEzIEBAIEhZUEVSVklTT1Jfc2V0X3RpbWVyX29wKHU2NCB0aW1lb3V0KQogfQogCiBzdGF0
aWMgaW5saW5lIGludAorSFlQRVJWSVNPUl9tY2Eoc3RydWN0IHhlbl9tYyAqbWNfb3ApCit7CisJ
bWNfb3AtPmludGVyZmFjZV92ZXJzaW9uID0gWEVOX01DQV9JTlRFUkZBQ0VfVkVSU0lPTjsKKwly
ZXR1cm4gX2h5cGVyY2FsbDEoaW50LCBtY2EsIG1jX29wKTsKK30KKworc3RhdGljIGlubGluZSBp
bnQKIEhZUEVSVklTT1JfZG9tMF9vcChzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wICpwbGF0Zm9ybV9v
cCkKIHsKIAlwbGF0Zm9ybV9vcC0+aW50ZXJmYWNlX3ZlcnNpb24gPSBYRU5QRl9JTlRFUkZBQ0Vf
VkVSU0lPTjsKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvbWNoZWNrL21jZS5jIGIv
YXJjaC94ODYva2VybmVsL2NwdS9tY2hlY2svbWNlLmMKaW5kZXggYjc3MmRkNi4uNWU1Yzg2MyAx
MDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9tY2hlY2svbWNlLmMKKysrIGIvYXJjaC94
ODYva2VybmVsL2NwdS9tY2hlY2svbWNlLmMKQEAgLTU3LDggKzU3LDYgQEAgc3RhdGljIERFRklO
RV9NVVRFWChtY2VfY2hyZGV2X3JlYWRfbXV0ZXgpOwogCiBpbnQgbWNlX2Rpc2FibGVkIF9fcmVh
ZF9tb3N0bHk7CiAKLSNkZWZpbmUgTUlTQ19NQ0VMT0dfTUlOT1IJMjI3Ci0KICNkZWZpbmUgU1BJ
TlVOSVQgMTAwCS8qIDEwMG5zICovCiAKIGF0b21pY190IG1jZV9lbnRyeTsKQEAgLTIzNDEsNyAr
MjMzOSw3IEBAIHN0YXRpYyBfX2luaXQgaW50IG1jaGVja19pbml0X2RldmljZSh2b2lkKQogCiAJ
cmV0dXJuIGVycjsKIH0KLWRldmljZV9pbml0Y2FsbChtY2hlY2tfaW5pdF9kZXZpY2UpOworZGV2
aWNlX2luaXRjYWxsX3N5bmMobWNoZWNrX2luaXRfZGV2aWNlKTsKIAogLyoKICAqIE9sZCBzdHls
ZSBib290IG9wdGlvbnMgcGFyc2luZy4gT25seSBmb3IgY29tcGF0aWJpbGl0eS4KZGlmZiAtLWdp
dCBhL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYyBiL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYwpp
bmRleCA3NWYzM2IyLi5mZjJkMDBlIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni94ZW4vZW5saWdodGVu
LmMKKysrIGIvYXJjaC94ODYveGVuL2VubGlnaHRlbi5jCkBAIC0zOCw2ICszOCw3IEBACiAjaW5j
bHVkZSA8eGVuL2ludGVyZmFjZS9waHlzZGV2Lmg+CiAjaW5jbHVkZSA8eGVuL2ludGVyZmFjZS92
Y3B1Lmg+CiAjaW5jbHVkZSA8eGVuL2ludGVyZmFjZS9tZW1vcnkuaD4KKyNpbmNsdWRlIDx4ZW4v
aW50ZXJmYWNlL3hlbi1tY2EuaD4KICNpbmNsdWRlIDx4ZW4vZmVhdHVyZXMuaD4KICNpbmNsdWRl
IDx4ZW4vcGFnZS5oPgogI2luY2x1ZGUgPHhlbi9odm0uaD4KQEAgLTMzMyw5ICszMzQsNyBAQCBz
dGF0aWMgdm9pZCBfX2luaXQgeGVuX2luaXRfY3B1aWRfbWFzayh2b2lkKQogCXVuc2lnbmVkIGlu
dCB4c2F2ZV9tYXNrOwogCiAJY3B1aWRfbGVhZjFfZWR4X21hc2sgPQotCQl+KCgxIDw8IFg4Nl9G
RUFUVVJFX01DRSkgIHwgIC8qIGRpc2FibGUgTUNFICovCi0JCSAgKDEgPDwgWDg2X0ZFQVRVUkVf
TUNBKSAgfCAgLyogZGlzYWJsZSBNQ0EgKi8KLQkJICAoMSA8PCBYODZfRkVBVFVSRV9NVFJSKSB8
ICAvKiBkaXNhYmxlIE1UUlIgKi8KKwkJfigoMSA8PCBYODZfRkVBVFVSRV9NVFJSKSB8ICAvKiBk
aXNhYmxlIE1UUlIgKi8KIAkJICAoMSA8PCBYODZfRkVBVFVSRV9BQ0MpKTsgICAvKiB0aGVybWFs
IG1vbml0b3JpbmcgKi8KIAogCWlmICgheGVuX2luaXRpYWxfZG9tYWluKCkpCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3hlbi9LY29uZmlnIGIvZHJpdmVycy94ZW4vS2NvbmZpZwppbmRleCA4ZDI1MDFl
Li5kNGRmZmNkIDEwMDY0NAotLS0gYS9kcml2ZXJzL3hlbi9LY29uZmlnCisrKyBiL2RyaXZlcnMv
eGVuL0tjb25maWcKQEAgLTE5Niw0ICsxOTYsMTIgQEAgY29uZmlnIFhFTl9BQ1BJX1BST0NFU1NP
UgogCSAgY2FsbGVkIHhlbl9hY3BpX3Byb2Nlc3NvciAgSWYgeW91IGRvIG5vdCBrbm93IHdoYXQg
dG8gY2hvb3NlLCBzZWxlY3QKIAkgIE0gaGVyZS4gSWYgdGhlIENQVUZSRVEgZHJpdmVycyBhcmUg
YnVpbHQgaW4sIHNlbGVjdCBZIGhlcmUuCiAKK2NvbmZpZyBYRU5fTUNFX0xPRworCWJvb2wgIlhl
biBwbGF0Zm9ybSBtY2Vsb2ciCisJZGVwZW5kcyBvbiBYRU5fRE9NMCAmJiBYODZfNjQgJiYgWDg2
X01DRQorCWRlZmF1bHQgbgorCWhlbHAKKwkgIEFsbG93IGtlcm5lbCBmZXRjaGluZyBNQ0UgZXJy
b3IgZnJvbSBYZW4gcGxhdGZvcm0gYW5kCisJICBjb252ZXJ0aW5nIGl0IGludG8gTGludXggbWNl
bG9nIGZvcm1hdCBmb3IgbWNlbG9nIHRvb2xzCisKIGVuZG1lbnUKZGlmZiAtLWdpdCBhL2RyaXZl
cnMveGVuL01ha2VmaWxlIGIvZHJpdmVycy94ZW4vTWFrZWZpbGUKaW5kZXggZmMzNDg4Ni4uYTc4
NzAyOSAxMDA2NDQKLS0tIGEvZHJpdmVycy94ZW4vTWFrZWZpbGUKKysrIGIvZHJpdmVycy94ZW4v
TWFrZWZpbGUKQEAgLTE4LDYgKzE4LDcgQEAgb2JqLSQoQ09ORklHX1hFTl9QVkhWTSkJCQkrPSBw
bGF0Zm9ybS1wY2kubwogb2JqLSQoQ09ORklHX1hFTl9UTUVNKQkJCSs9IHRtZW0ubwogb2JqLSQo
Q09ORklHX1NXSU9UTEJfWEVOKQkJKz0gc3dpb3RsYi14ZW4ubwogb2JqLSQoQ09ORklHX1hFTl9E
T00wKQkJCSs9IHBjaS5vIGFjcGkubworb2JqLSQoQ09ORklHX1hFTl9NQ0VfTE9HKQkJKz0gbWNl
bG9nLm8KIG9iai0kKENPTkZJR19YRU5fUENJREVWX0JBQ0tFTkQpCSs9IHhlbi1wY2liYWNrLwog
b2JqLSQoQ09ORklHX1hFTl9QUklWQ01EKQkJKz0geGVuLXByaXZjbWQubwogb2JqLSQoQ09ORklH
X1hFTl9BQ1BJX1BST0NFU1NPUikJKz0geGVuLWFjcGktcHJvY2Vzc29yLm8KZGlmZiAtLWdpdCBh
L2RyaXZlcnMveGVuL21jZWxvZy5jIGIvZHJpdmVycy94ZW4vbWNlbG9nLmMKbmV3IGZpbGUgbW9k
ZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uNzJlODdkMgotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZl
cnMveGVuL21jZWxvZy5jCkBAIC0wLDAgKzEsMzkyIEBACisvKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
CisgKiBtY2Vsb2cuYworICogRHJpdmVyIGZvciByZWNlaXZpbmcgYW5kIHRyYW5zZmVycmluZyBt
YWNoaW5lIGNoZWNrIGVycm9yIGluZm9tYXRpb24KKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTIg
SW50ZWwgQ29ycG9yYXRpb24KKyAqIEF1dGhvcjogTGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBp
bnRlbC5jb20+CisgKiBBdXRob3I6IEppYW5nLCBZdW5ob25nIDx5dW5ob25nLmppYW5nQGludGVs
LmNvbT4KKyAqIEF1dGhvcjogS2UsIExpcGluZyA8bGlwaW5nLmtlQGludGVsLmNvbT4KKyAqCisg
KiBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQg
YW5kL29yCisgKiBtb2RpZnkgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQ
dWJsaWMgTGljZW5zZSB2ZXJzaW9uIDIKKyAqIGFzIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0
d2FyZSBGb3VuZGF0aW9uOyBvciwgd2hlbiBkaXN0cmlidXRlZAorICogc2VwYXJhdGVseSBmcm9t
IHRoZSBMaW51eCBrZXJuZWwgb3IgaW5jb3Jwb3JhdGVkIGludG8gb3RoZXIKKyAqIHNvZnR3YXJl
IHBhY2thZ2VzLCBzdWJqZWN0IHRvIHRoZSBmb2xsb3dpbmcgbGljZW5zZToKKyAqCisgKiBQZXJt
aXNzaW9uIGlzIGhlcmVieSBncmFudGVkLCBmcmVlIG9mIGNoYXJnZSwgdG8gYW55IHBlcnNvbiBv
YnRhaW5pbmcgYSBjb3B5CisgKiBvZiB0aGlzIHNvdXJjZSBmaWxlICh0aGUgIlNvZnR3YXJlIiks
IHRvIGRlYWwgaW4gdGhlIFNvZnR3YXJlIHdpdGhvdXQKKyAqIHJlc3RyaWN0aW9uLCBpbmNsdWRp
bmcgd2l0aG91dCBsaW1pdGF0aW9uIHRoZSByaWdodHMgdG8gdXNlLCBjb3B5LCBtb2RpZnksCisg
KiBtZXJnZSwgcHVibGlzaCwgZGlzdHJpYnV0ZSwgc3VibGljZW5zZSwgYW5kL29yIHNlbGwgY29w
aWVzIG9mIHRoZSBTb2Z0d2FyZSwKKyAqIGFuZCB0byBwZXJtaXQgcGVyc29ucyB0byB3aG9tIHRo
ZSBTb2Z0d2FyZSBpcyBmdXJuaXNoZWQgdG8gZG8gc28sIHN1YmplY3QgdG8KKyAqIHRoZSBmb2xs
b3dpbmcgY29uZGl0aW9uczoKKyAqCisgKiBUaGUgYWJvdmUgY29weXJpZ2h0IG5vdGljZSBhbmQg
dGhpcyBwZXJtaXNzaW9uIG5vdGljZSBzaGFsbCBiZSBpbmNsdWRlZCBpbgorICogYWxsIGNvcGll
cyBvciBzdWJzdGFudGlhbCBwb3J0aW9ucyBvZiB0aGUgU29mdHdhcmUuCisgKgorICogVEhFIFNP
RlRXQVJFIElTIFBST1ZJREVEICJBUyBJUyIsIFdJVEhPVVQgV0FSUkFOVFkgT0YgQU5ZIEtJTkQs
IEVYUFJFU1MgT1IKKyAqIElNUExJRUQsIElOQ0xVRElORyBCVVQgTk9UIExJTUlURUQgVE8gVEhF
IFdBUlJBTlRJRVMgT0YgTUVSQ0hBTlRBQklMSVRZLAorICogRklUTkVTUyBGT1IgQSBQQVJUSUNV
TEFSIFBVUlBPU0UgQU5EIE5PTklORlJJTkdFTUVOVC4gSU4gTk8gRVZFTlQgU0hBTEwgVEhFCisg
KiBBVVRIT1JTIE9SIENPUFlSSUdIVCBIT0xERVJTIEJFIExJQUJMRSBGT1IgQU5ZIENMQUlNLCBE
QU1BR0VTIE9SIE9USEVSCisgKiBMSUFCSUxJVFksIFdIRVRIRVIgSU4gQU4gQUNUSU9OIE9GIENP
TlRSQUNULCBUT1JUIE9SIE9USEVSV0lTRSwgQVJJU0lORworICogRlJPTSwgT1VUIE9GIE9SIElO
IENPTk5FQ1RJT04gV0lUSCBUSEUgU09GVFdBUkUgT1IgVEhFIFVTRSBPUiBPVEhFUiBERUFMSU5H
UworICogSU4gVEhFIFNPRlRXQVJFLgorICovCisKKyNpbmNsdWRlIDxsaW51eC9pbml0Lmg+Cisj
aW5jbHVkZSA8bGludXgvdHlwZXMuaD4KKyNpbmNsdWRlIDxsaW51eC9rZXJuZWwuaD4KKyNpbmNs
dWRlIDxsaW51eC9zbGFiLmg+CisjaW5jbHVkZSA8bGludXgvZnMuaD4KKyNpbmNsdWRlIDxsaW51
eC9kZXZpY2UuaD4KKyNpbmNsdWRlIDxsaW51eC9taXNjZGV2aWNlLmg+CisjaW5jbHVkZSA8bGlu
dXgvdWFjY2Vzcy5oPgorI2luY2x1ZGUgPGxpbnV4L2NhcGFiaWxpdHkuaD4KKworI2luY2x1ZGUg
PHhlbi9pbnRlcmZhY2UveGVuLmg+CisjaW5jbHVkZSA8eGVuL2V2ZW50cy5oPgorI2luY2x1ZGUg
PHhlbi9pbnRlcmZhY2UvdmNwdS5oPgorI2luY2x1ZGUgPHhlbi94ZW4uaD4KKyNpbmNsdWRlIDxh
c20veGVuL2h5cGVyY2FsbC5oPgorI2luY2x1ZGUgPGFzbS94ZW4vaHlwZXJ2aXNvci5oPgorCisj
ZGVmaW5lIFhFTl9NQ0VMT0cgInhlbl9tY2Vsb2c6ICIKKworc3RhdGljIHN0cnVjdCBtY19pbmZv
IGdfbWk7CitzdGF0aWMgc3RydWN0IG1jaW5mb19sb2dpY2FsX2NwdSAqZ19waHlzaW5mbzsKK3N0
YXRpYyB1aW50MzJfdCBuY3B1czsKKworc3RhdGljIERFRklORV9TUElOTE9DSyhtY2Vsb2dfbG9j
ayk7CisKK3N0YXRpYyBzdHJ1Y3QgeGVuX21jZV9sb2cgeGVuX21jZWxvZyA9IHsKKwkuc2lnbmF0
dXJlCT0gWEVOX01DRV9MT0dfU0lHTkFUVVJFLAorCS5sZW4JCT0gWEVOX01DRV9MT0dfTEVOLAor
CS5yZWNvcmRsZW4JPSBzaXplb2Yoc3RydWN0IHhlbl9tY2UpLAorfTsKKworc3RhdGljIERFRklO
RV9TUElOTE9DSyh4ZW5fbWNlX2NocmRldl9zdGF0ZV9sb2NrKTsKK3N0YXRpYyBpbnQgeGVuX21j
ZV9jaHJkZXZfb3Blbl9jb3VudDsJLyogI3RpbWVzIG9wZW5lZCAqLworc3RhdGljIGludCB4ZW5f
bWNlX2NocmRldl9vcGVuX2V4Y2x1OwkvKiBhbHJlYWR5IG9wZW4gZXhjbHVzaXZlPyAqLworCitz
dGF0aWMgaW50IHhlbl9tY2VfY2hyZGV2X29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0
IGZpbGUgKmZpbGUpCit7CisJc3Bpbl9sb2NrKCZ4ZW5fbWNlX2NocmRldl9zdGF0ZV9sb2NrKTsK
KworCWlmICh4ZW5fbWNlX2NocmRldl9vcGVuX2V4Y2x1IHx8CisJICAgICh4ZW5fbWNlX2NocmRl
dl9vcGVuX2NvdW50ICYmIChmaWxlLT5mX2ZsYWdzICYgT19FWENMKSkpIHsKKwkJc3Bpbl91bmxv
Y2soJnhlbl9tY2VfY2hyZGV2X3N0YXRlX2xvY2spOworCisJCXJldHVybiAtRUJVU1k7CisJfQor
CisJaWYgKGZpbGUtPmZfZmxhZ3MgJiBPX0VYQ0wpCisJCXhlbl9tY2VfY2hyZGV2X29wZW5fZXhj
bHUgPSAxOworCXhlbl9tY2VfY2hyZGV2X29wZW5fY291bnQrKzsKKworCXNwaW5fdW5sb2NrKCZ4
ZW5fbWNlX2NocmRldl9zdGF0ZV9sb2NrKTsKKworCXJldHVybiBub25zZWVrYWJsZV9vcGVuKGlu
b2RlLCBmaWxlKTsKK30KKworc3RhdGljIGludCB4ZW5fbWNlX2NocmRldl9yZWxlYXNlKHN0cnVj
dCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQoreworCXNwaW5fbG9jaygmeGVuX21j
ZV9jaHJkZXZfc3RhdGVfbG9jayk7CisKKwl4ZW5fbWNlX2NocmRldl9vcGVuX2NvdW50LS07CisJ
eGVuX21jZV9jaHJkZXZfb3Blbl9leGNsdSA9IDA7CisKKwlzcGluX3VubG9jaygmeGVuX21jZV9j
aHJkZXZfc3RhdGVfbG9jayk7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIHNzaXplX3QgeGVu
X21jZV9jaHJkZXZfcmVhZChzdHJ1Y3QgZmlsZSAqZmlscCwgY2hhciBfX3VzZXIgKnVidWYsCisJ
CQkJc2l6ZV90IHVzaXplLCBsb2ZmX3QgKm9mZikKK3sKKwljaGFyIF9fdXNlciAqYnVmID0gdWJ1
ZjsKKwl1bnNpZ25lZCBudW07CisJaW50IGksIGVycjsKKworCXNwaW5fbG9jaygmbWNlbG9nX2xv
Y2spOworCisJbnVtID0geGVuX21jZWxvZy5uZXh0OworCisJLyogT25seSBzdXBwb3J0cyBmdWxs
IHJlYWRzIHJpZ2h0IG5vdyAqLworCWVyciA9IC1FSU5WQUw7CisJaWYgKCpvZmYgIT0gMCB8fCB1
c2l6ZSA8IFhFTl9NQ0VfTE9HX0xFTipzaXplb2Yoc3RydWN0IHhlbl9tY2UpKQorCQlnb3RvIG91
dDsKKworCWVyciA9IDA7CisJZm9yIChpID0gMDsgaSA8IG51bTsgaSsrKSB7CisJCXN0cnVjdCB4
ZW5fbWNlICptID0gJnhlbl9tY2Vsb2cuZW50cnlbaV07CisKKwkJZXJyIHw9IGNvcHlfdG9fdXNl
cihidWYsIG0sIHNpemVvZigqbSkpOworCQlidWYgKz0gc2l6ZW9mKCptKTsKKwl9CisKKwltZW1z
ZXQoeGVuX21jZWxvZy5lbnRyeSwgMCwgbnVtICogc2l6ZW9mKHN0cnVjdCB4ZW5fbWNlKSk7CisJ
eGVuX21jZWxvZy5uZXh0ID0gMDsKKworCWlmIChlcnIpCisJCWVyciA9IC1FRkFVTFQ7CisKK291
dDoKKwlzcGluX3VubG9jaygmbWNlbG9nX2xvY2spOworCisJcmV0dXJuIGVyciA/IGVyciA6IGJ1
ZiAtIHVidWY7Cit9CisKK3N0YXRpYyBsb25nIHhlbl9tY2VfY2hyZGV2X2lvY3RsKHN0cnVjdCBm
aWxlICpmLCB1bnNpZ25lZCBpbnQgY21kLAorCQkJCXVuc2lnbmVkIGxvbmcgYXJnKQoreworCWlu
dCBfX3VzZXIgKnAgPSAoaW50IF9fdXNlciAqKWFyZzsKKworCWlmICghY2FwYWJsZShDQVBfU1lT
X0FETUlOKSkKKwkJcmV0dXJuIC1FUEVSTTsKKworCXN3aXRjaCAoY21kKSB7CisJY2FzZSBNQ0Vf
R0VUX1JFQ09SRF9MRU46CisJCXJldHVybiBwdXRfdXNlcihzaXplb2Yoc3RydWN0IHhlbl9tY2Up
LCBwKTsKKwljYXNlIE1DRV9HRVRfTE9HX0xFTjoKKwkJcmV0dXJuIHB1dF91c2VyKFhFTl9NQ0Vf
TE9HX0xFTiwgcCk7CisJY2FzZSBNQ0VfR0VUQ0xFQVJfRkxBR1M6IHsKKwkJdW5zaWduZWQgZmxh
Z3M7CisKKwkJZG8geworCQkJZmxhZ3MgPSB4ZW5fbWNlbG9nLmZsYWdzOworCQl9IHdoaWxlIChj
bXB4Y2hnKCZ4ZW5fbWNlbG9nLmZsYWdzLCBmbGFncywgMCkgIT0gZmxhZ3MpOworCisJCXJldHVy
biBwdXRfdXNlcihmbGFncywgcCk7CisJfQorCWRlZmF1bHQ6CisJCXJldHVybiAtRU5PVFRZOwor
CX0KK30KKworc3RhdGljIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgeGVuX21jZV9jaHJk
ZXZfb3BzID0geworCS5vcGVuCQkJPSB4ZW5fbWNlX2NocmRldl9vcGVuLAorCS5yZWxlYXNlCQk9
IHhlbl9tY2VfY2hyZGV2X3JlbGVhc2UsCisJLnJlYWQJCQk9IHhlbl9tY2VfY2hyZGV2X3JlYWQs
CisJLnVubG9ja2VkX2lvY3RsCQk9IHhlbl9tY2VfY2hyZGV2X2lvY3RsLAorCS5sbHNlZWsJCQk9
IG5vX2xsc2VlaywKK307CisKK3N0YXRpYyBzdHJ1Y3QgbWlzY2RldmljZSB4ZW5fbWNlX2NocmRl
dl9kZXZpY2UgPSB7CisJTUlTQ19NQ0VMT0dfTUlOT1IsCisJIm1jZWxvZyIsCisJJnhlbl9tY2Vf
Y2hyZGV2X29wcywKK307CisKKy8qCisgKiBDYWxsZXIgc2hvdWxkIGhvbGQgdGhlIG1jZWxvZ19s
b2NrCisgKi8KK3N0YXRpYyB2b2lkIHhlbl9tY2VfbG9nKHN0cnVjdCB4ZW5fbWNlICptY2UpCit7
CisJdW5zaWduZWQgZW50cnk7CisKKwllbnRyeSA9IHhlbl9tY2Vsb2cubmV4dDsKKworCS8qCisJ
ICogV2hlbiB0aGUgYnVmZmVyIGZpbGxzIHVwIGRpc2NhcmQgbmV3IGVudHJpZXMuCisJICogQXNz
dW1lIHRoYXQgdGhlIGVhcmxpZXIgZXJyb3JzIGFyZSB0aGUgbW9yZQorCSAqIGludGVyZXN0aW5n
IG9uZXM6CisJICovCisJaWYgKGVudHJ5ID49IFhFTl9NQ0VfTE9HX0xFTikgeworCQlzZXRfYml0
KFhFTl9NQ0VfT1ZFUkZMT1csCisJCQkodW5zaWduZWQgbG9uZyAqKSZ4ZW5fbWNlbG9nLmZsYWdz
KTsKKwkJcmV0dXJuOworCX0KKworCW1lbWNweSh4ZW5fbWNlbG9nLmVudHJ5ICsgZW50cnksIG1j
ZSwgc2l6ZW9mKHN0cnVjdCB4ZW5fbWNlKSk7CisKKwl4ZW5fbWNlbG9nLm5leHQrKzsKK30KKwor
c3RhdGljIGludCBjb252ZXJ0X2xvZyhzdHJ1Y3QgbWNfaW5mbyAqbWkpCit7CisJc3RydWN0IG1j
aW5mb19jb21tb24gKm1pYzsKKwlzdHJ1Y3QgbWNpbmZvX2dsb2JhbCAqbWNfZ2xvYmFsOworCXN0
cnVjdCBtY2luZm9fYmFuayAqbWNfYmFuazsKKwlzdHJ1Y3QgeGVuX21jZSBtOworCXVpbnQzMl90
IGk7CisKKwltaWMgPSBOVUxMOworCXg4Nl9tY2luZm9fbG9va3VwKCZtaWMsIG1pLCBNQ19UWVBF
X0dMT0JBTCk7CisJaWYgKHVubGlrZWx5KCFtaWMpKSB7CisJCXByX3dhcm5pbmcoWEVOX01DRUxP
RyAiRmFpbGVkIHRvIGZpbmQgZ2xvYmFsIGVycm9yIGluZm9cbiIpOworCQlyZXR1cm4gLUVOT0RF
VjsKKwl9CisKKwltZW1zZXQoJm0sIDAsIHNpemVvZihzdHJ1Y3QgeGVuX21jZSkpOworCisJbWNf
Z2xvYmFsID0gKHN0cnVjdCBtY2luZm9fZ2xvYmFsICopbWljOworCW0ubWNnc3RhdHVzID0gbWNf
Z2xvYmFsLT5tY19nc3RhdHVzOworCW0uYXBpY2lkID0gbWNfZ2xvYmFsLT5tY19hcGljaWQ7CisK
Kwlmb3IgKGkgPSAwOyBpIDwgbmNwdXM7IGkrKykKKwkJaWYgKGdfcGh5c2luZm9baV0ubWNfYXBp
Y2lkID09IG0uYXBpY2lkKQorCQkJYnJlYWs7CisJaWYgKHVubGlrZWx5KGkgPT0gbmNwdXMpKSB7
CisJCXByX3dhcm5pbmcoWEVOX01DRUxPRyAiRmFpbGVkIHRvIG1hdGNoIGNwdSB3aXRoIGFwaWNp
ZCAlZFxuIiwKKwkJCSAgIG0uYXBpY2lkKTsKKwkJcmV0dXJuIC1FTk9ERVY7CisJfQorCisJbS5z
b2NrZXRpZCA9IGdfcGh5c2luZm9baV0ubWNfY2hpcGlkOworCW0uY3B1ID0gbS5leHRjcHUgPSBn
X3BoeXNpbmZvW2ldLm1jX2NwdW5yOworCW0uY3B1dmVuZG9yID0gKF9fdTgpZ19waHlzaW5mb1tp
XS5tY192ZW5kb3I7CisJbS5tY2djYXAgPSBnX3BoeXNpbmZvW2ldLm1jX21zcnZhbHVlc1tfX01D
X01TUl9NQ0dDQVBdLnZhbHVlOworCisJbWljID0gTlVMTDsKKwl4ODZfbWNpbmZvX2xvb2t1cCgm
bWljLCBtaSwgTUNfVFlQRV9CQU5LKTsKKwlpZiAodW5saWtlbHkoIW1pYykpIHsKKwkJcHJfd2Fy
bmluZyhYRU5fTUNFTE9HICJGYWlsIHRvIGZpbmQgYmFuayBlcnJvciBpbmZvXG4iKTsKKwkJcmV0
dXJuIC1FTk9ERVY7CisJfQorCisJZG8geworCQlpZiAoKCFtaWMpIHx8IChtaWMtPnNpemUgPT0g
MCkgfHwKKwkJICAgIChtaWMtPnR5cGUgIT0gTUNfVFlQRV9HTE9CQUwgICAmJgorCQkgICAgIG1p
Yy0+dHlwZSAhPSBNQ19UWVBFX0JBTksgICAgICYmCisJCSAgICAgbWljLT50eXBlICE9IE1DX1RZ
UEVfRVhURU5ERUQgJiYKKwkJICAgICBtaWMtPnR5cGUgIT0gTUNfVFlQRV9SRUNPVkVSWSkpCisJ
CQlicmVhazsKKworCQlpZiAobWljLT50eXBlID09IE1DX1RZUEVfQkFOSykgeworCQkJbWNfYmFu
ayA9IChzdHJ1Y3QgbWNpbmZvX2JhbmsgKiltaWM7CisJCQltLm1pc2MgPSBtY19iYW5rLT5tY19t
aXNjOworCQkJbS5zdGF0dXMgPSBtY19iYW5rLT5tY19zdGF0dXM7CisJCQltLmFkZHIgPSBtY19i
YW5rLT5tY19hZGRyOworCQkJbS50c2MgPSBtY19iYW5rLT5tY190c2M7CisJCQltLmJhbmsgPSBt
Y19iYW5rLT5tY19iYW5rOworCQkJbS5maW5pc2hlZCA9IDE7CisJCQkvKmxvZyB0aGlzIHJlY29y
ZCovCisJCQl4ZW5fbWNlX2xvZygmbSk7CisJCX0KKwkJbWljID0geDg2X21jaW5mb19uZXh0KG1p
Yyk7CisJfSB3aGlsZSAoMSk7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCBtY19xdWV1
ZV9oYW5kbGUodWludDMyX3QgZmxhZ3MpCit7CisJc3RydWN0IHhlbl9tYyBtY19vcDsKKwlpbnQg
cmV0ID0gMDsKKworCW1jX29wLmNtZCA9IFhFTl9NQ19mZXRjaDsKKwltY19vcC5pbnRlcmZhY2Vf
dmVyc2lvbiA9IFhFTl9NQ0FfSU5URVJGQUNFX1ZFUlNJT047CisJc2V0X3hlbl9ndWVzdF9oYW5k
bGUobWNfb3AudS5tY19mZXRjaC5kYXRhLCAmZ19taSk7CisJZG8geworCQltY19vcC51Lm1jX2Zl
dGNoLmZsYWdzID0gZmxhZ3M7CisJCXJldCA9IEhZUEVSVklTT1JfbWNhKCZtY19vcCk7CisJCWlm
IChyZXQpIHsKKwkJCXByX2VycihYRU5fTUNFTE9HICJGYWlsZWQgdG8gZmV0Y2ggJXMgZXJyb3Ig
bG9nXG4iLAorCQkJICAgICAgIChmbGFncyA9PSBYRU5fTUNfVVJHRU5UKSA/CisJCQkgICAgICAg
InVyZ25ldCIgOiAibm9udXJnZW50Iik7CisJCQlicmVhazsKKwkJfQorCisJCWlmIChtY19vcC51
Lm1jX2ZldGNoLmZsYWdzICYgWEVOX01DX05PREFUQSB8fAorCQkgICAgbWNfb3AudS5tY19mZXRj
aC5mbGFncyAmIFhFTl9NQ19GRVRDSEZBSUxFRCkKKwkJCWJyZWFrOworCQllbHNlIHsKKwkJCXJl
dCA9IGNvbnZlcnRfbG9nKCZnX21pKTsKKwkJCWlmIChyZXQpCisJCQkJcHJfd2FybmluZyhYRU5f
TUNFTE9HCisJCQkJCSAgICJGYWlsZWQgdG8gY29udmVydCB0aGlzIGVycm9yIGxvZywgIgorCQkJ
CQkgICAiY29udGludWUgYWNraW5nIGl0IGFueXdheVxuIik7CisKKwkJCW1jX29wLnUubWNfZmV0
Y2guZmxhZ3MgPSBmbGFncyB8IFhFTl9NQ19BQ0s7CisJCQlyZXQgPSBIWVBFUlZJU09SX21jYSgm
bWNfb3ApOworCQkJaWYgKHJldCkgeworCQkJCXByX2VycihYRU5fTUNFTE9HCisJCQkJICAgICAg
ICJGYWlsZWQgdG8gYWNrIHByZXZpb3VzIGVycm9yIGxvZ1xuIik7CisJCQkJYnJlYWs7CisJCQl9
CisJCX0KKwl9IHdoaWxlICgxKTsKKworCXJldHVybiByZXQ7Cit9CisKKy8qIHZpcnEgaGFuZGxl
ciBmb3IgbWFjaGluZSBjaGVjayBlcnJvciBpbmZvKi8KK3N0YXRpYyBpcnFyZXR1cm5fdCB4ZW5f
bWNlX2ludGVycnVwdChpbnQgaXJxLCB2b2lkICpkZXZfaWQpCit7CisJaW50IGVycjsKKwl1bnNp
Z25lZCBsb25nIHRtcDsKKworCXNwaW5fbG9ja19pcnFzYXZlKCZtY2Vsb2dfbG9jaywgdG1wKTsK
KworCS8qIHVyZ2VudCBtY19pbmZvICovCisJZXJyID0gbWNfcXVldWVfaGFuZGxlKFhFTl9NQ19V
UkdFTlQpOworCWlmIChlcnIpCisJCXByX2VycihYRU5fTUNFTE9HCisJCSAgICAgICAiRmFpbGVk
IHRvIGhhbmRsZSB1cmdlbnQgbWNfaW5mbyBxdWV1ZSwgIgorCQkgICAgICAgImNvbnRpbnVlIGhh
bmRsaW5nIG5vbnVyZ2VudCBtY19pbmZvIHF1ZXVlIGFueXdheS5cbiIpOworCisJLyogbm9udXJn
ZW50IG1jX2luZm8gKi8KKwllcnIgPSBtY19xdWV1ZV9oYW5kbGUoWEVOX01DX05PTlVSR0VOVCk7
CisJaWYgKGVycikKKwkJcHJfZXJyKFhFTl9NQ0VMT0cKKwkJICAgICAgICJGYWlsZWQgdG8gaGFu
ZGxlIG5vbnVyZ2VudCBtY19pbmZvIHF1ZXVlLlxuIik7CisKKwlzcGluX3VubG9ja19pcnFyZXN0
b3JlKCZtY2Vsb2dfbG9jaywgdG1wKTsKKworCXJldHVybiBJUlFfSEFORExFRDsKK30KKworc3Rh
dGljIGludCBiaW5kX3ZpcnFfZm9yX21jZSh2b2lkKQoreworCWludCByZXQ7CisJc3RydWN0IHhl
bl9tYyBtY19vcDsKKworCW1lbXNldCgmbWNfb3AsIDAsIHNpemVvZihzdHJ1Y3QgeGVuX21jKSk7
CisKKwkvKiBGZXRjaCBwaHlzaWNhbCBDUFUgTnVtYmVycyAqLworCW1jX29wLmNtZCA9IFhFTl9N
Q19waHlzY3B1aW5mbzsKKwltY19vcC5pbnRlcmZhY2VfdmVyc2lvbiA9IFhFTl9NQ0FfSU5URVJG
QUNFX1ZFUlNJT047CisJc2V0X3hlbl9ndWVzdF9oYW5kbGUobWNfb3AudS5tY19waHlzY3B1aW5m
by5pbmZvLCBnX3BoeXNpbmZvKTsKKwlyZXQgPSBIWVBFUlZJU09SX21jYSgmbWNfb3ApOworCWlm
IChyZXQpIHsKKwkJcHJfZXJyKFhFTl9NQ0VMT0cgIkZhaWxlZCB0byBnZXQgQ1BVIG51bWJlcnNc
biIpOworCQlyZXR1cm4gcmV0OworCX0KKworCS8qIEZldGNoIGVhY2ggQ1BVIFBoeXNpY2FsIElu
Zm8gZm9yIGxhdGVyIHJlZmVyZW5jZSovCisJbmNwdXMgPSBtY19vcC51Lm1jX3BoeXNjcHVpbmZv
Lm5jcHVzOworCWdfcGh5c2luZm8gPSBrY2FsbG9jKG5jcHVzLCBzaXplb2Yoc3RydWN0IG1jaW5m
b19sb2dpY2FsX2NwdSksCisJCQkgICAgIEdGUF9LRVJORUwpOworCWlmICghZ19waHlzaW5mbykK
KwkJcmV0dXJuIC1FTk9NRU07CisJc2V0X3hlbl9ndWVzdF9oYW5kbGUobWNfb3AudS5tY19waHlz
Y3B1aW5mby5pbmZvLCBnX3BoeXNpbmZvKTsKKwlyZXQgPSBIWVBFUlZJU09SX21jYSgmbWNfb3Ap
OworCWlmIChyZXQpIHsKKwkJcHJfZXJyKFhFTl9NQ0VMT0cgIkZhaWxlZCB0byBnZXQgQ1BVIGlu
Zm9cbiIpOworCQlrZnJlZShnX3BoeXNpbmZvKTsKKwkJcmV0dXJuIHJldDsKKwl9CisKKwlyZXQg
ID0gYmluZF92aXJxX3RvX2lycWhhbmRsZXIoVklSUV9NQ0EsIDAsCisJCQkJICAgICAgIHhlbl9t
Y2VfaW50ZXJydXB0LCAwLCAibWNlIiwgTlVMTCk7CisJaWYgKHJldCA8IDApIHsKKwkJcHJfZXJy
KFhFTl9NQ0VMT0cgIkZhaWxlZCB0byBiaW5kIHZpcnFcbiIpOworCQlrZnJlZShnX3BoeXNpbmZv
KTsKKwkJcmV0dXJuIHJldDsKKwl9CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCBfX2lu
aXQgeGVuX2xhdGVfaW5pdF9tY2Vsb2codm9pZCkKK3sKKwkvKiBPbmx5IERPTTAgaXMgcmVzcG9u
c2libGUgZm9yIE1DRSBsb2dnaW5nICovCisJaWYgKHhlbl9pbml0aWFsX2RvbWFpbigpKSB7CisJ
CS8qIHJlZ2lzdGVyIGNoYXJhY3RlciBkZXZpY2UgL2Rldi9tY2Vsb2cgZm9yIHhlbiBtY2Vsb2cg
Ki8KKwkJaWYgKG1pc2NfcmVnaXN0ZXIoJnhlbl9tY2VfY2hyZGV2X2RldmljZSkpCisJCQlyZXR1
cm4gLUVOT0RFVjsKKwkJcmV0dXJuIGJpbmRfdmlycV9mb3JfbWNlKCk7CisJfQorCisJcmV0dXJu
IC1FTk9ERVY7Cit9CitkZXZpY2VfaW5pdGNhbGwoeGVuX2xhdGVfaW5pdF9tY2Vsb2cpOwpkaWZm
IC0tZ2l0IGEvaW5jbHVkZS9saW51eC9taXNjZGV2aWNlLmggYi9pbmNsdWRlL2xpbnV4L21pc2Nk
ZXZpY2UuaAppbmRleCAwNTQ5ZDIxLi5lMGRlZWIyIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4
L21pc2NkZXZpY2UuaAorKysgYi9pbmNsdWRlL2xpbnV4L21pc2NkZXZpY2UuaApAQCAtMzUsNiAr
MzUsNyBAQAogI2RlZmluZSBNUFRfTUlOT1IJCTIyMAogI2RlZmluZSBNUFQyU0FTX01JTk9SCQky
MjEKICNkZWZpbmUgVUlOUFVUX01JTk9SCQkyMjMKKyNkZWZpbmUgTUlTQ19NQ0VMT0dfTUlOT1IJ
MjI3CiAjZGVmaW5lIEhQRVRfTUlOT1IJCTIyOAogI2RlZmluZSBGVVNFX01JTk9SCQkyMjkKICNk
ZWZpbmUgS1ZNX01JTk9SCQkyMzIKZGlmZiAtLWdpdCBhL2luY2x1ZGUveGVuL2ludGVyZmFjZS94
ZW4tbWNhLmggYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2UveGVuLW1jYS5oCm5ldyBmaWxlIG1vZGUg
MTAwNjQ0CmluZGV4IDAwMDAwMDAuLjczYTRlYTcKLS0tIC9kZXYvbnVsbAorKysgYi9pbmNsdWRl
L3hlbi9pbnRlcmZhY2UveGVuLW1jYS5oCkBAIC0wLDAgKzEsMzg1IEBACisvKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqCisgKiBhcmNoLXg4Ni9tY2EuaAorICogR3Vlc3QgT1MgbWFjaGluZSBjaGVjayBp
bnRlcmZhY2UgdG8geDg2IFhlbi4KKyAqCisgKiBDb250cmlidXRlZCBieSBBZHZhbmNlZCBNaWNy
byBEZXZpY2VzLCBJbmMuCisgKiBBdXRob3I6IENocmlzdG9waCBFZ2dlciA8Q2hyaXN0b3BoLkVn
Z2VyQGFtZC5jb20+CisgKgorICogVXBkYXRlZCBieSBJbnRlbCBDb3Jwb3JhdGlvbgorICogQXV0
aG9yOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4KKyAqCisgKiBQZXJtaXNz
aW9uIGlzIGhlcmVieSBncmFudGVkLCBmcmVlIG9mIGNoYXJnZSwgdG8gYW55IHBlcnNvbiBvYnRh
aW5pbmcgYSBjb3B5CisgKiBvZiB0aGlzIHNvZnR3YXJlIGFuZCBhc3NvY2lhdGVkIGRvY3VtZW50
YXRpb24gZmlsZXMgKHRoZSAiU29mdHdhcmUiKSwgdG8KKyAqIGRlYWwgaW4gdGhlIFNvZnR3YXJl
IHdpdGhvdXQgcmVzdHJpY3Rpb24sIGluY2x1ZGluZyB3aXRob3V0IGxpbWl0YXRpb24gdGhlCisg
KiByaWdodHMgdG8gdXNlLCBjb3B5LCBtb2RpZnksIG1lcmdlLCBwdWJsaXNoLCBkaXN0cmlidXRl
LCBzdWJsaWNlbnNlLCBhbmQvb3IKKyAqIHNlbGwgY29waWVzIG9mIHRoZSBTb2Z0d2FyZSwgYW5k
IHRvIHBlcm1pdCBwZXJzb25zIHRvIHdob20gdGhlIFNvZnR3YXJlIGlzCisgKiBmdXJuaXNoZWQg
dG8gZG8gc28sIHN1YmplY3QgdG8gdGhlIGZvbGxvd2luZyBjb25kaXRpb25zOgorICoKKyAqIFRo
ZSBhYm92ZSBjb3B5cmlnaHQgbm90aWNlIGFuZCB0aGlzIHBlcm1pc3Npb24gbm90aWNlIHNoYWxs
IGJlIGluY2x1ZGVkIGluCisgKiBhbGwgY29waWVzIG9yIHN1YnN0YW50aWFsIHBvcnRpb25zIG9m
IHRoZSBTb2Z0d2FyZS4KKyAqCisgKiBUSEUgU09GVFdBUkUgSVMgUFJPVklERUQgIkFTIElTIiwg
V0lUSE9VVCBXQVJSQU5UWSBPRiBBTlkgS0lORCwgRVhQUkVTUyBPUgorICogSU1QTElFRCwgSU5D
TFVESU5HIEJVVCBOT1QgTElNSVRFRCBUTyBUSEUgV0FSUkFOVElFUyBPRiBNRVJDSEFOVEFCSUxJ
VFksCisgKiBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRSBBTkQgTk9OSU5GUklOR0VN
RU5ULiBJTiBOTyBFVkVOVCBTSEFMTCBUSEUKKyAqIEFVVEhPUlMgT1IgQ09QWVJJR0hUIEhPTERF
UlMgQkUgTElBQkxFIEZPUiBBTlkgQ0xBSU0sIERBTUFHRVMgT1IgT1RIRVIKKyAqIExJQUJJTElU
WSwgV0hFVEhFUiBJTiBBTiBBQ1RJT04gT0YgQ09OVFJBQ1QsIFRPUlQgT1IgT1RIRVJXSVNFLCBB
UklTSU5HCisgKiBGUk9NLCBPVVQgT0YgT1IgSU4gQ09OTkVDVElPTiBXSVRIIFRIRSBTT0ZUV0FS
RSBPUiBUSEUgVVNFIE9SIE9USEVSCisgKiBERUFMSU5HUyBJTiBUSEUgU09GVFdBUkUuCisgKi8K
KworI2lmbmRlZiBfX1hFTl9QVUJMSUNfQVJDSF9YODZfTUNBX0hfXworI2RlZmluZSBfX1hFTl9Q
VUJMSUNfQVJDSF9YODZfTUNBX0hfXworCisvKiBIeXBlcmNhbGwgKi8KKyNkZWZpbmUgX19IWVBF
UlZJU09SX21jYSBfX0hZUEVSVklTT1JfYXJjaF8wCisKKyNkZWZpbmUgWEVOX01DQV9JTlRFUkZB
Q0VfVkVSU0lPTgkweDAxZWNjMDAzCisKKy8qIElOOiBEb20wIGNhbGxzIGh5cGVyY2FsbCB0byBy
ZXRyaWV2ZSBub251cmdlbnQgZXJyb3IgbG9nIGVudHJ5ICovCisjZGVmaW5lIFhFTl9NQ19OT05V
UkdFTlQJMHgxCisvKiBJTjogRG9tMCBjYWxscyBoeXBlcmNhbGwgdG8gcmV0cmlldmUgdXJnZW50
IGVycm9yIGxvZyBlbnRyeSAqLworI2RlZmluZSBYRU5fTUNfVVJHRU5UCQkweDIKKy8qIElOOiBE
b20wIGFja25vd2xlZGdlcyBwcmV2aW9zbHktZmV0Y2hlZCBlcnJvciBsb2cgZW50cnkgKi8KKyNk
ZWZpbmUgWEVOX01DX0FDSwkJMHg0CisKKy8qIE9VVDogQWxsIGlzIG9rICovCisjZGVmaW5lIFhF
Tl9NQ19PSwkJMHgwCisvKiBPVVQ6IERvbWFpbiBjb3VsZCBub3QgZmV0Y2ggZGF0YS4gKi8KKyNk
ZWZpbmUgWEVOX01DX0ZFVENIRkFJTEVECTB4MQorLyogT1VUOiBUaGVyZSB3YXMgbm8gbWFjaGlu
ZSBjaGVjayBkYXRhIHRvIGZldGNoLiAqLworI2RlZmluZSBYRU5fTUNfTk9EQVRBCQkweDIKKwor
I2lmbmRlZiBfX0FTU0VNQkxZX18KKy8qIHZJUlEgaW5qZWN0ZWQgdG8gRG9tMCAqLworI2RlZmlu
ZSBWSVJRX01DQSBWSVJRX0FSQ0hfMAorCisvKgorICogbWNfaW5mbyBlbnRyeSB0eXBlcworICog
bWNhIG1hY2hpbmUgY2hlY2sgaW5mbyBhcmUgcmVjb3JkZWQgaW4gbWNfaW5mbyBlbnRyaWVzLgor
ICogd2hlbiBmZXRjaCBtY2EgaW5mbywgaXQgY2FuIHVzZSBNQ19UWVBFXy4uLiB0byBkaXN0aW5n
dWlzaAorICogZGlmZmVyZW50IG1jYSBpbmZvLgorICovCisjZGVmaW5lIE1DX1RZUEVfR0xPQkFM
CQkwCisjZGVmaW5lIE1DX1RZUEVfQkFOSwkJMQorI2RlZmluZSBNQ19UWVBFX0VYVEVOREVECTIK
KyNkZWZpbmUgTUNfVFlQRV9SRUNPVkVSWQkzCisKK3N0cnVjdCBtY2luZm9fY29tbW9uIHsKKwl1
aW50MTZfdCB0eXBlOyAvKiBzdHJ1Y3R1cmUgdHlwZSAqLworCXVpbnQxNl90IHNpemU7IC8qIHNp
emUgb2YgdGhpcyBzdHJ1Y3QgaW4gYnl0ZXMgKi8KK307CisKKyNkZWZpbmUgTUNfRkxBR19DT1JS
RUNUQUJMRQkoMSA8PCAwKQorI2RlZmluZSBNQ19GTEFHX1VOQ09SUkVDVEFCTEUJKDEgPDwgMSkK
KyNkZWZpbmUgTUNfRkxBR19SRUNPVkVSQUJMRQkoMSA8PCAyKQorI2RlZmluZSBNQ19GTEFHX1BP
TExFRAkJKDEgPDwgMykKKyNkZWZpbmUgTUNfRkxBR19SRVNFVAkJKDEgPDwgNCkKKyNkZWZpbmUg
TUNfRkxBR19DTUNJCQkoMSA8PCA1KQorI2RlZmluZSBNQ19GTEFHX01DRQkJKDEgPDwgNikKKwor
LyogY29udGFpbnMgeDg2IGdsb2JhbCBtYyBpbmZvcm1hdGlvbiAqLworc3RydWN0IG1jaW5mb19n
bG9iYWwgeworCXN0cnVjdCBtY2luZm9fY29tbW9uIGNvbW1vbjsKKworCXVpbnQxNl90IG1jX2Rv
bWlkOyAvKiBydW5uaW5nIGRvbWFpbiBhdCB0aGUgdGltZSBpbiBlcnJvciAqLworCXVpbnQxNl90
IG1jX3ZjcHVpZDsgLyogdmlydHVhbCBjcHUgc2NoZWR1bGVkIGZvciBtY19kb21pZCAqLworCXVp
bnQzMl90IG1jX3NvY2tldGlkOyAvKiBwaHlzaWNhbCBzb2NrZXQgb2YgdGhlIHBoeXNpY2FsIGNv
cmUgKi8KKwl1aW50MTZfdCBtY19jb3JlaWQ7IC8qIHBoeXNpY2FsIGltcGFjdGVkIGNvcmUgKi8K
Kwl1aW50MTZfdCBtY19jb3JlX3RocmVhZGlkOyAvKiBjb3JlIHRocmVhZCBvZiBwaHlzaWNhbCBj
b3JlICovCisJdWludDMyX3QgbWNfYXBpY2lkOworCXVpbnQzMl90IG1jX2ZsYWdzOworCXVpbnQ2
NF90IG1jX2dzdGF0dXM7IC8qIGdsb2JhbCBzdGF0dXMgKi8KK307CisKKy8qIGNvbnRhaW5zIHg4
NiBiYW5rIG1jIGluZm9ybWF0aW9uICovCitzdHJ1Y3QgbWNpbmZvX2JhbmsgeworCXN0cnVjdCBt
Y2luZm9fY29tbW9uIGNvbW1vbjsKKworCXVpbnQxNl90IG1jX2Jhbms7IC8qIGJhbmsgbnIgKi8K
Kwl1aW50MTZfdCBtY19kb21pZDsgLyogZG9tYWluIHJlZmVyZW5jZWQgYnkgbWNfYWRkciBpZiB2
YWxpZCAqLworCXVpbnQ2NF90IG1jX3N0YXR1czsgLyogYmFuayBzdGF0dXMgKi8KKwl1aW50NjRf
dCBtY19hZGRyOyAvKiBiYW5rIGFkZHJlc3MgKi8KKwl1aW50NjRfdCBtY19taXNjOworCXVpbnQ2
NF90IG1jX2N0cmwyOworCXVpbnQ2NF90IG1jX3RzYzsKK307CisKK3N0cnVjdCBtY2luZm9fbXNy
IHsKKwl1aW50NjRfdCByZWc7IC8qIE1TUiAqLworCXVpbnQ2NF90IHZhbHVlOyAvKiBNU1IgdmFs
dWUgKi8KK307CisKKy8qIGNvbnRhaW5zIG1jIGluZm9ybWF0aW9uIGZyb20gb3RoZXIgb3IgYWRk
aXRpb25hbCBtYyBNU1JzICovCitzdHJ1Y3QgbWNpbmZvX2V4dGVuZGVkIHsKKwlzdHJ1Y3QgbWNp
bmZvX2NvbW1vbiBjb21tb247CisJdWludDMyX3QgbWNfbXNyczsgLyogTnVtYmVyIG9mIG1zciB3
aXRoIHZhbGlkIHZhbHVlcy4gKi8KKwkvKgorCSAqIEN1cnJlbnRseSBJbnRlbCBleHRlbmRlZCBN
U1IgKDMyLzY0KSBpbmNsdWRlIGFsbCBncCByZWdpc3RlcnMKKwkgKiBhbmQgRShSKUZMQUdTLCBF
KFIpSVAsIEUoUilNSVNDLCB1cCB0byAxMS8xOSBvZiB0aGVtIG1pZ2h0IGJlCisJICogdXNlZnVs
IGF0IHByZXNlbnQuIFNvIGV4cGFuZCB0aGlzIGFycmF5IHRvIDE2LzMyIHRvIGxlYXZlIHJvb20u
CisJICovCisJc3RydWN0IG1jaW5mb19tc3IgbWNfbXNyW3NpemVvZih2b2lkICopICogNF07Cit9
OworCisvKiBSZWNvdmVyeSBBY3Rpb24gZmxhZ3MuIEdpdmluZyByZWNvdmVyeSByZXN1bHQgaW5m
b3JtYXRpb24gdG8gRE9NMCAqLworCisvKiBYZW4gdGFrZXMgc3VjY2Vzc2Z1bCByZWNvdmVyeSBh
Y3Rpb24sIHRoZSBlcnJvciBpcyByZWNvdmVyZWQgKi8KKyNkZWZpbmUgUkVDX0FDVElPTl9SRUNP
VkVSRUQgKDB4MSA8PCAwKQorLyogTm8gYWN0aW9uIGlzIHBlcmZvcm1lZCBieSBYRU4gKi8KKyNk
ZWZpbmUgUkVDX0FDVElPTl9OT05FICgweDEgPDwgMSkKKy8qIEl0J3MgcG9zc2libGUgRE9NMCBt
aWdodCB0YWtlIGFjdGlvbiBvd25lcnNoaXAgaW4gc29tZSBjYXNlICovCisjZGVmaW5lIFJFQ19B
Q1RJT05fTkVFRF9SRVNFVCAoMHgxIDw8IDIpCisKKy8qCisgKiBEaWZmZXJlbnQgUmVjb3Zlcnkg
QWN0aW9uIHR5cGVzLCBpZiB0aGUgYWN0aW9uIGlzIHBlcmZvcm1lZCBzdWNjZXNzZnVsbHksCisg
KiBSRUNfQUNUSU9OX1JFQ09WRVJFRCBmbGFnIHdpbGwgYmUgcmV0dXJuZWQuCisgKi8KKworLyog
UGFnZSBPZmZsaW5lIEFjdGlvbiAqLworI2RlZmluZSBNQ19BQ1RJT05fUEFHRV9PRkZMSU5FICgw
eDEgPDwgMCkKKy8qIENQVSBvZmZsaW5lIEFjdGlvbiAqLworI2RlZmluZSBNQ19BQ1RJT05fQ1BV
X09GRkxJTkUgKDB4MSA8PCAxKQorLyogTDMgY2FjaGUgZGlzYWJsZSBBY3Rpb24gKi8KKyNkZWZp
bmUgTUNfQUNUSU9OX0NBQ0hFX1NIUklOSyAoMHgxIDw8IDIpCisKKy8qCisgKiBCZWxvdyBpbnRl
cmZhY2UgdXNlZCBiZXR3ZWVuIFhFTi9ET00wIGZvciBwYXNzaW5nIFhFTidzIHJlY292ZXJ5IGFj
dGlvbgorICogaW5mb3JtYXRpb24gdG8gRE9NMC4KKyAqLworc3RydWN0IHBhZ2Vfb2ZmbGluZV9h
Y3Rpb24geworCS8qIFBhcmFtcyBmb3IgcGFzc2luZyB0aGUgb2ZmbGluZWQgcGFnZSBudW1iZXIg
dG8gRE9NMCAqLworCXVpbnQ2NF90IG1mbjsKKwl1aW50NjRfdCBzdGF0dXM7Cit9OworCitzdHJ1
Y3QgY3B1X29mZmxpbmVfYWN0aW9uIHsKKwkvKiBQYXJhbXMgZm9yIHBhc3NpbmcgdGhlIGlkZW50
aXR5IG9mIHRoZSBvZmZsaW5lZCBDUFUgdG8gRE9NMCAqLworCXVpbnQzMl90IG1jX3NvY2tldGlk
OworCXVpbnQxNl90IG1jX2NvcmVpZDsKKwl1aW50MTZfdCBtY19jb3JlX3RocmVhZGlkOworfTsK
KworI2RlZmluZSBNQVhfVU5JT05fU0laRSAxNgorc3RydWN0IG1jaW5mb19yZWNvdmVyeSB7CisJ
c3RydWN0IG1jaW5mb19jb21tb24gY29tbW9uOworCXVpbnQxNl90IG1jX2Jhbms7IC8qIGJhbmsg
bnIgKi8KKwl1aW50OF90IGFjdGlvbl9mbGFnczsKKwl1aW50OF90IGFjdGlvbl90eXBlczsKKwl1
bmlvbiB7CisJCXN0cnVjdCBwYWdlX29mZmxpbmVfYWN0aW9uIHBhZ2VfcmV0aXJlOworCQlzdHJ1
Y3QgY3B1X29mZmxpbmVfYWN0aW9uIGNwdV9vZmZsaW5lOworCQl1aW50OF90IHBhZFtNQVhfVU5J
T05fU0laRV07CisJfSBhY3Rpb25faW5mbzsKK307CisKKworI2RlZmluZSBNQ0lORk9fTUFYU0la
RSA3NjgKK3N0cnVjdCBtY19pbmZvIHsKKwkvKiBOdW1iZXIgb2YgbWNpbmZvXyogZW50cmllcyBp
biBtaV9kYXRhICovCisJdWludDMyX3QgbWlfbmVudHJpZXM7CisJdWludDMyX3QgZmxhZ3M7CisJ
dWludDY0X3QgbWlfZGF0YVsoTUNJTkZPX01BWFNJWkUgLSAxKSAvIDhdOworfTsKK0RFRklORV9H
VUVTVF9IQU5ETEVfU1RSVUNUKG1jX2luZm8pOworCisjZGVmaW5lIF9fTUNfTVNSX0FSUkFZU0la
RSA4CisjZGVmaW5lIF9fTUNfTVNSX01DR0NBUCAwCisjZGVmaW5lIF9fTUNfTk1TUlMgMQorI2Rl
ZmluZSBNQ19OQ0FQUyA3CitzdHJ1Y3QgbWNpbmZvX2xvZ2ljYWxfY3B1IHsKKwl1aW50MzJfdCBt
Y19jcHVucjsKKwl1aW50MzJfdCBtY19jaGlwaWQ7CisJdWludDE2X3QgbWNfY29yZWlkOworCXVp
bnQxNl90IG1jX3RocmVhZGlkOworCXVpbnQzMl90IG1jX2FwaWNpZDsKKwl1aW50MzJfdCBtY19j
bHVzdGVyaWQ7CisJdWludDMyX3QgbWNfbmNvcmVzOworCXVpbnQzMl90IG1jX25jb3Jlc19hY3Rp
dmU7CisJdWludDMyX3QgbWNfbnRocmVhZHM7CisJdWludDMyX3QgbWNfY3B1aWRfbGV2ZWw7CisJ
dWludDMyX3QgbWNfZmFtaWx5OworCXVpbnQzMl90IG1jX3ZlbmRvcjsKKwl1aW50MzJfdCBtY19t
b2RlbDsKKwl1aW50MzJfdCBtY19zdGVwOworCWNoYXIgbWNfdmVuZG9yaWRbMTZdOworCWNoYXIg
bWNfYnJhbmRpZFs2NF07CisJdWludDMyX3QgbWNfY3B1X2NhcHNbTUNfTkNBUFNdOworCXVpbnQz
Ml90IG1jX2NhY2hlX3NpemU7CisJdWludDMyX3QgbWNfY2FjaGVfYWxpZ25tZW50OworCXVpbnQz
Ml90IG1jX25tc3J2YWxzOworCXN0cnVjdCBtY2luZm9fbXNyIG1jX21zcnZhbHVlc1tfX01DX01T
Ul9BUlJBWVNJWkVdOworfTsKK0RFRklORV9HVUVTVF9IQU5ETEVfU1RSVUNUKG1jaW5mb19sb2dp
Y2FsX2NwdSk7CisKKy8qCisgKiBQcm90b3R5cGU6CisgKiAgICB1aW50MzJfdCB4ODZfbWNpbmZv
X25lbnRyaWVzKHN0cnVjdCBtY19pbmZvICptaSk7CisgKi8KKyNkZWZpbmUgeDg2X21jaW5mb19u
ZW50cmllcyhfbWkpICAgIFwKKwkoKF9taSktPm1pX25lbnRyaWVzKQorLyoKKyAqIFByb3RvdHlw
ZToKKyAqICAgIHN0cnVjdCBtY2luZm9fY29tbW9uICp4ODZfbWNpbmZvX2ZpcnN0KHN0cnVjdCBt
Y19pbmZvICptaSk7CisgKi8KKyNkZWZpbmUgeDg2X21jaW5mb19maXJzdChfbWkpICAgICAgIFwK
KwkoKHN0cnVjdCBtY2luZm9fY29tbW9uICopKF9taSktPm1pX2RhdGEpCisvKgorICogUHJvdG90
eXBlOgorICogICAgc3RydWN0IG1jaW5mb19jb21tb24gKng4Nl9tY2luZm9fbmV4dChzdHJ1Y3Qg
bWNpbmZvX2NvbW1vbiAqbWljKTsKKyAqLworI2RlZmluZSB4ODZfbWNpbmZvX25leHQoX21pYykg
ICAgICAgXAorCSgoc3RydWN0IG1jaW5mb19jb21tb24gKikoKHVpbnQ4X3QgKikoX21pYykgKyAo
X21pYyktPnNpemUpKQorCisvKgorICogUHJvdG90eXBlOgorICogICAgdm9pZCB4ODZfbWNpbmZv
X2xvb2t1cCh2b2lkICpyZXQsIHN0cnVjdCBtY19pbmZvICptaSwgdWludDE2X3QgdHlwZSk7Cisg
Ki8KK3N0YXRpYyBpbmxpbmUgdm9pZCB4ODZfbWNpbmZvX2xvb2t1cChzdHJ1Y3QgbWNpbmZvX2Nv
bW1vbiAqKnJldCwKKwkJCQkgICAgIHN0cnVjdCBtY19pbmZvICptaSwgdWludDE2X3QgdHlwZSkK
K3sKKwl1aW50MzJfdCBpOworCXN0cnVjdCBtY2luZm9fY29tbW9uICptaWM7CisJYm9vbCBmb3Vu
ZCA9IDA7CisKKwlpZiAoIXJldCB8fCAhbWkpCisJCXJldHVybjsKKworCW1pYyA9IHg4Nl9tY2lu
Zm9fZmlyc3QobWkpOworCWZvciAoaSA9IDA7IGkgPCB4ODZfbWNpbmZvX25lbnRyaWVzKG1pKTsg
aSsrKSB7CisJCWlmIChtaWMtPnR5cGUgPT0gdHlwZSkgeworCQkJZm91bmQgPSAxOworCQkJYnJl
YWs7CisJCX0KKwkJbWljID0geDg2X21jaW5mb19uZXh0KG1pYyk7CisJfQorCisJKnJldCA9IGZv
dW5kID8gbWljIDogTlVMTDsKK30KKworLyoKKyAqIEZldGNoIG1hY2hpbmUgY2hlY2sgZGF0YSBm
cm9tIGh5cGVydmlzb3IuCisgKi8KKyNkZWZpbmUgWEVOX01DX2ZldGNoCQkxCitzdHJ1Y3QgeGVu
X21jX2ZldGNoIHsKKwkvKgorCSAqIElOOiBYRU5fTUNfTk9OVVJHRU5ULCBYRU5fTUNfVVJHRU5U
LAorCSAqIFhFTl9NQ19BQ0sgaWYgYWNrJ2tpbmcgYW4gZWFybGllciBmZXRjaAorCSAqIE9VVDog
WEVOX01DX09LLCBYRU5fTUNfRkVUQ0hBSUxFRCwgWEVOX01DX05PREFUQQorCSAqLworCXVpbnQz
Ml90IGZsYWdzOworCXVpbnQzMl90IF9wYWQwOworCS8qIE9VVDogaWQgZm9yIGFjaywgSU46IGlk
IHdlIGFyZSBhY2snaW5nICovCisJdWludDY0X3QgZmV0Y2hfaWQ7CisKKwkvKiBPVVQgdmFyaWFi
bGVzLiAqLworCUdVRVNUX0hBTkRMRShtY19pbmZvKSBkYXRhOworfTsKK0RFRklORV9HVUVTVF9I
QU5ETEVfU1RSVUNUKHhlbl9tY19mZXRjaCk7CisKKworLyoKKyAqIFRoaXMgdGVsbHMgdGhlIGh5
cGVydmlzb3IgdG8gbm90aWZ5IGEgRG9tVSBhYm91dCB0aGUgbWFjaGluZSBjaGVjayBlcnJvcgor
ICovCisjZGVmaW5lIFhFTl9NQ19ub3RpZnlkb21haW4JMgorc3RydWN0IHhlbl9tY19ub3RpZnlk
b21haW4geworCS8qIElOIHZhcmlhYmxlcyAqLworCXVpbnQxNl90IG1jX2RvbWlkOyAvKiBUaGUg
dW5wcml2aWxlZ2VkIGRvbWFpbiB0byBub3RpZnkgKi8KKwl1aW50MTZfdCBtY192Y3B1aWQ7IC8q
IFRoZSB2Y3B1IGluIG1jX2RvbWlkIHRvIG5vdGlmeSAqLworCisJLyogSU4vT1VUIHZhcmlhYmxl
cyAqLworCXVpbnQzMl90IGZsYWdzOworfTsKK0RFRklORV9HVUVTVF9IQU5ETEVfU1RSVUNUKHhl
bl9tY19ub3RpZnlkb21haW4pOworCisjZGVmaW5lIFhFTl9NQ19waHlzY3B1aW5mbwkzCitzdHJ1
Y3QgeGVuX21jX3BoeXNjcHVpbmZvIHsKKwkvKiBJTi9PVVQgKi8KKwl1aW50MzJfdCBuY3B1czsK
Kwl1aW50MzJfdCBfcGFkMDsKKwkvKiBPVVQgKi8KKwlHVUVTVF9IQU5ETEUobWNpbmZvX2xvZ2lj
YWxfY3B1KSBpbmZvOworfTsKKworI2RlZmluZSBYRU5fTUNfbXNyaW5qZWN0CTQKKyNkZWZpbmUg
TUNfTVNSSU5KX01BWE1TUlMJOAorc3RydWN0IHhlbl9tY19tc3JpbmplY3QgeworCS8qIElOICov
CisJdWludDMyX3QgbWNpbmpfY3B1bnI7IC8qIHRhcmdldCBwcm9jZXNzb3IgaWQgKi8KKwl1aW50
MzJfdCBtY2lual9mbGFnczsgLyogc2VlIE1DX01TUklOSl9GXyogYmVsb3cgKi8KKwl1aW50MzJf
dCBtY2lual9jb3VudDsgLyogMCAuLiBjb3VudC0xIGluIGFycmF5IGFyZSB2YWxpZCAqLworCXVp
bnQzMl90IF9wYWQwOworCXN0cnVjdCBtY2luZm9fbXNyIG1jaW5qX21zcltNQ19NU1JJTkpfTUFY
TVNSU107Cit9OworCisvKiBGbGFncyBmb3IgbWNpbmpfZmxhZ3MgYWJvdmU7IGJpdHMgMTYtMzEg
YXJlIHJlc2VydmVkICovCisjZGVmaW5lIE1DX01TUklOSl9GX0lOVEVSUE9TRQkweDEKKworI2Rl
ZmluZSBYRU5fTUNfbWNlaW5qZWN0CTUKK3N0cnVjdCB4ZW5fbWNfbWNlaW5qZWN0IHsKKwl1bnNp
Z25lZCBpbnQgbWNlaW5qX2NwdW5yOyAvKiB0YXJnZXQgcHJvY2Vzc29yIGlkICovCit9OworCitz
dHJ1Y3QgeGVuX21jIHsKKwl1aW50MzJfdCBjbWQ7CisJdWludDMyX3QgaW50ZXJmYWNlX3ZlcnNp
b247IC8qIFhFTl9NQ0FfSU5URVJGQUNFX1ZFUlNJT04gKi8KKwl1bmlvbiB7CisJCXN0cnVjdCB4
ZW5fbWNfZmV0Y2ggICAgICAgIG1jX2ZldGNoOworCQlzdHJ1Y3QgeGVuX21jX25vdGlmeWRvbWFp
biBtY19ub3RpZnlkb21haW47CisJCXN0cnVjdCB4ZW5fbWNfcGh5c2NwdWluZm8gIG1jX3BoeXNj
cHVpbmZvOworCQlzdHJ1Y3QgeGVuX21jX21zcmluamVjdCAgICBtY19tc3JpbmplY3Q7CisJCXN0
cnVjdCB4ZW5fbWNfbWNlaW5qZWN0ICAgIG1jX21jZWluamVjdDsKKwl9IHU7Cit9OworREVGSU5F
X0dVRVNUX0hBTkRMRV9TVFJVQ1QoeGVuX21jKTsKKworLyogRmllbGRzIGFyZSB6ZXJvIHdoZW4g
bm90IGF2YWlsYWJsZSAqLworc3RydWN0IHhlbl9tY2UgeworCV9fdTY0IHN0YXR1czsKKwlfX3U2
NCBtaXNjOworCV9fdTY0IGFkZHI7CisJX191NjQgbWNnc3RhdHVzOworCV9fdTY0IGlwOworCV9f
dTY0IHRzYzsJLyogY3B1IHRpbWUgc3RhbXAgY291bnRlciAqLworCV9fdTY0IHRpbWU7CS8qIHdh
bGwgdGltZV90IHdoZW4gZXJyb3Igd2FzIGRldGVjdGVkICovCisJX191OCAgY3B1dmVuZG9yOwkv
KiBjcHUgdmVuZG9yIGFzIGVuY29kZWQgaW4gc3lzdGVtLmggKi8KKwlfX3U4ICBpbmplY3RfZmxh
Z3M7CS8qIHNvZnR3YXJlIGluamVjdCBmbGFncyAqLworCV9fdTE2ICBwYWQ7CisJX191MzIgY3B1
aWQ7CS8qIENQVUlEIDEgRUFYICovCisJX191OCAgY3M7CQkvKiBjb2RlIHNlZ21lbnQgKi8KKwlf
X3U4ICBiYW5rOwkvKiBtYWNoaW5lIGNoZWNrIGJhbmsgKi8KKwlfX3U4ICBjcHU7CS8qIGNwdSBu
dW1iZXI7IG9ic29sZXRlOyB1c2UgZXh0Y3B1IG5vdyAqLworCV9fdTggIGZpbmlzaGVkOyAgIC8q
IGVudHJ5IGlzIHZhbGlkICovCisJX191MzIgZXh0Y3B1OwkvKiBsaW51eCBjcHUgbnVtYmVyIHRo
YXQgZGV0ZWN0ZWQgdGhlIGVycm9yICovCisJX191MzIgc29ja2V0aWQ7CS8qIENQVSBzb2NrZXQg
SUQgKi8KKwlfX3UzMiBhcGljaWQ7CS8qIENQVSBpbml0aWFsIGFwaWMgSUQgKi8KKwlfX3U2NCBt
Y2djYXA7CS8qIE1DR0NBUCBNU1I6IG1hY2hpbmUgY2hlY2sgY2FwYWJpbGl0aWVzIG9mIENQVSAq
LworfTsKKworLyoKKyAqIFRoaXMgc3RydWN0dXJlIGNvbnRhaW5zIGFsbCBkYXRhIHJlbGF0ZWQg
dG8gdGhlIE1DRSBsb2cuICBBbHNvCisgKiBjYXJyaWVzIGEgc2lnbmF0dXJlIHRvIG1ha2UgaXQg
ZWFzaWVyIHRvIGZpbmQgZnJvbSBleHRlcm5hbAorICogZGVidWdnaW5nIHRvb2xzLiAgRWFjaCBl
bnRyeSBpcyBvbmx5IHZhbGlkIHdoZW4gaXRzIGZpbmlzaGVkIGZsYWcKKyAqIGlzIHNldC4KKyAq
LworCisjZGVmaW5lIFhFTl9NQ0VfTE9HX0xFTiAzMgorCitzdHJ1Y3QgeGVuX21jZV9sb2cgewor
CWNoYXIgc2lnbmF0dXJlWzEyXTsgLyogIk1BQ0hJTkVDSEVDSyIgKi8KKwl1bnNpZ25lZCBsZW47
CSAgICAvKiA9IFhFTl9NQ0VfTE9HX0xFTiAqLworCXVuc2lnbmVkIG5leHQ7CisJdW5zaWduZWQg
ZmxhZ3M7CisJdW5zaWduZWQgcmVjb3JkbGVuOwkvKiBsZW5ndGggb2Ygc3RydWN0IHhlbl9tY2Ug
Ki8KKwlzdHJ1Y3QgeGVuX21jZSBlbnRyeVtYRU5fTUNFX0xPR19MRU5dOworfTsKKworI2RlZmlu
ZSBYRU5fTUNFX09WRVJGTE9XIDAJCS8qIGJpdCAwIGluIGZsYWdzIG1lYW5zIG92ZXJmbG93ICov
CisKKyNkZWZpbmUgWEVOX01DRV9MT0dfU0lHTkFUVVJFCSJNQUNISU5FQ0hFQ0siCisKKyNkZWZp
bmUgTUNFX0dFVF9SRUNPUkRfTEVOICAgX0lPUignTScsIDEsIGludCkKKyNkZWZpbmUgTUNFX0dF
VF9MT0dfTEVOICAgICAgX0lPUignTScsIDIsIGludCkKKyNkZWZpbmUgTUNFX0dFVENMRUFSX0ZM
QUdTICAgX0lPUignTScsIDMsIGludCkKKworI2VuZGlmIC8qIF9fQVNTRU1CTFlfXyAqLworI2Vu
ZGlmIC8qIF9fWEVOX1BVQkxJQ19BUkNIX1g4Nl9NQ0FfSF9fICovCi0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC82923351FEE7CSHSMSX101ccrcorpi_--
