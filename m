Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab2EaRay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:30:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:5040 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab2EaRav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:30:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="106369076"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform
Thread-Topic: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform
Thread-Index: Ac0/UxzL4acV+iwERyy3wXcJqIVZkA==
Date: Thu, 31 May 2012 17:30:47 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351FFB48@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923351FFB48SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923351FFB48SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 5506f24e15c5d8adc3f501993660391211a2214a Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Fri, 1 Jun 2012 08:27:39 +0800
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

Signed-off-by: Ke, Liping <liping.ke@intel.com>
Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Acked-and-tested-by: Borislav Petkov <borislav.petkov@amd.com>
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

--_002_DE8DF0795D48FD4CA783C40EC82923351FFB48SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-xen-mce-Add-mcelog-support-for-Xen-platform.patch"
Content-Description: 0001-xen-mce-Add-mcelog-support-for-Xen-platform.patch
Content-Disposition: attachment;
	filename="0001-xen-mce-Add-mcelog-support-for-Xen-platform.patch";
	size=27134; creation-date="Thu, 31 May 2012 17:10:05 GMT";
	modification-date="Fri, 01 Jun 2012 00:43:22 GMT"
Content-Transfer-Encoding: base64

RnJvbSA1NTA2ZjI0ZTE1YzVkOGFkYzNmNTAxOTkzNjYwMzkxMjExYTIyMTRhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogRnJpLCAxIEp1biAyMDEyIDA4OjI3OjM5ICswODAwClN1YmplY3Q6IFtQQVRDSCAxLzNd
IHhlbi9tY2U6IEFkZCBtY2Vsb2cgc3VwcG9ydCBmb3IgWGVuIHBsYXRmb3JtCgpXaGVuIE1DQSBl
cnJvciBvY2N1cnMsIGl0IHdvdWxkIGJlIGhhbmRsZWQgYnkgWGVuIGh5cGVydmlzb3IgZmlyc3Qs
CmFuZCB0aGVuIHRoZSBlcnJvciBpbmZvcm1hdGlvbiB3b3VsZCBiZSBzZW50IHRvIGluaXRpYWwg
ZG9tYWluIGZvciBsb2dnaW5nLgoKVGhpcyBwYXRjaCBnZXRzIGVycm9yIGluZm9ybWF0aW9uIGZy
b20gWGVuIGh5cGVydmlzb3IgYW5kIGNvbnZlcnQKWGVuIGZvcm1hdCBlcnJvciBpbnRvIExpbnV4
IGZvcm1hdCBtY2Vsb2cuIFRoaXMgbG9naWMgaXMgYmFzaWNhbGx5CnNlbGYtY29udGFpbmVkLCBu
b3QgdG91Y2hpbmcgb3RoZXIga2VybmVsIGNvbXBvbmVudHMuCgpCeSB1c2luZyB0b29scyBsaWtl
IG1jZWxvZyB0b29sIHVzZXJzIGNvdWxkIHJlYWQgc3BlY2lmaWMgZXJyb3IgaW5mb3JtYXRpb24s
Cmxpa2Ugd2hhdCB0aGV5IGRpZCB1bmRlciBuYXRpdmUgTGludXguCgpUbyB0ZXN0IGZvbGxvdyBk
aXJlY3Rpb25zIG91dGxpbmVkIGluIERvY3VtZW50YXRpb24vYWNwaS9hcGVpL2VpbmoudHh0CgpT
aWduZWQtb2ZmLWJ5OiBLZSwgTGlwaW5nIDxsaXBpbmcua2VAaW50ZWwuY29tPgpTaWduZWQtb2Zm
LWJ5OiBKaWFuZywgWXVuaG9uZyA8eXVuaG9uZy5qaWFuZ0BpbnRlbC5jb20+ClNpZ25lZC1vZmYt
Ynk6IEplcmVteSBGaXR6aGFyZGluZ2UgPGplcmVteS5maXR6aGFyZGluZ2VAY2l0cml4LmNvbT4K
QWNrZWQtYW5kLXRlc3RlZC1ieTogQm9yaXNsYXYgUGV0a292IDxib3Jpc2xhdi5wZXRrb3ZAYW1k
LmNvbT4KU2lnbmVkLW9mZi1ieTogTGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+
Ci0tLQogYXJjaC94ODYvaW5jbHVkZS9hc20veGVuL2h5cGVyY2FsbC5oIHwgICAgOCArCiBhcmNo
L3g4Ni9rZXJuZWwvY3B1L21jaGVjay9tY2UuYyAgICAgfCAgICA0ICstCiBhcmNoL3g4Ni94ZW4v
ZW5saWdodGVuLmMgICAgICAgICAgICAgfCAgICA1ICstCiBkcml2ZXJzL3hlbi9LY29uZmlnICAg
ICAgICAgICAgICAgICAgfCAgICA4ICsKIGRyaXZlcnMveGVuL01ha2VmaWxlICAgICAgICAgICAg
ICAgICB8ICAgIDEgKwogZHJpdmVycy94ZW4vbWNlbG9nLmMgICAgICAgICAgICAgICAgIHwgIDM5
MiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCiBpbmNsdWRlL2xpbnV4L21pc2Nk
ZXZpY2UuaCAgICAgICAgICAgfCAgICAxICsKIGluY2x1ZGUveGVuL2ludGVyZmFjZS94ZW4tbWNh
LmggICAgICB8ICAzODUgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCiA4IGZpbGVz
IGNoYW5nZWQsIDc5OCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQogY3JlYXRlIG1vZGUg
MTAwNjQ0IGRyaXZlcnMveGVuL21jZWxvZy5jCiBjcmVhdGUgbW9kZSAxMDA2NDQgaW5jbHVkZS94
ZW4vaW50ZXJmYWNlL3hlbi1tY2EuaAoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNt
L3hlbi9oeXBlcmNhbGwuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3hlbi9oeXBlcmNhbGwuaApp
bmRleCA1NzI4ODUyLi41OWMyMjZkIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS94
ZW4vaHlwZXJjYWxsLmgKKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20veGVuL2h5cGVyY2FsbC5o
CkBAIC00OCw2ICs0OCw3IEBACiAjaW5jbHVkZSA8eGVuL2ludGVyZmFjZS9zY2hlZC5oPgogI2lu
Y2x1ZGUgPHhlbi9pbnRlcmZhY2UvcGh5c2Rldi5oPgogI2luY2x1ZGUgPHhlbi9pbnRlcmZhY2Uv
cGxhdGZvcm0uaD4KKyNpbmNsdWRlIDx4ZW4vaW50ZXJmYWNlL3hlbi1tY2EuaD4KIAogLyoKICAq
IFRoZSBoeXBlcmNhbGwgYXNtcyBoYXZlIHRvIG1lZXQgc2V2ZXJhbCBjb25zdHJhaW50czoKQEAg
LTMwMiw2ICszMDMsMTMgQEAgSFlQRVJWSVNPUl9zZXRfdGltZXJfb3AodTY0IHRpbWVvdXQpCiB9
CiAKIHN0YXRpYyBpbmxpbmUgaW50CitIWVBFUlZJU09SX21jYShzdHJ1Y3QgeGVuX21jICptY19v
cCkKK3sKKwltY19vcC0+aW50ZXJmYWNlX3ZlcnNpb24gPSBYRU5fTUNBX0lOVEVSRkFDRV9WRVJT
SU9OOworCXJldHVybiBfaHlwZXJjYWxsMShpbnQsIG1jYSwgbWNfb3ApOworfQorCitzdGF0aWMg
aW5saW5lIGludAogSFlQRVJWSVNPUl9kb20wX29wKHN0cnVjdCB4ZW5fcGxhdGZvcm1fb3AgKnBs
YXRmb3JtX29wKQogewogCXBsYXRmb3JtX29wLT5pbnRlcmZhY2VfdmVyc2lvbiA9IFhFTlBGX0lO
VEVSRkFDRV9WRVJTSU9OOwpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2NwdS9tY2hlY2sv
bWNlLmMgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L21jaGVjay9tY2UuYwppbmRleCBiNzcyZGQ2Li41
ZTVjODYzIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L21jaGVjay9tY2UuYworKysg
Yi9hcmNoL3g4Ni9rZXJuZWwvY3B1L21jaGVjay9tY2UuYwpAQCAtNTcsOCArNTcsNiBAQCBzdGF0
aWMgREVGSU5FX01VVEVYKG1jZV9jaHJkZXZfcmVhZF9tdXRleCk7CiAKIGludCBtY2VfZGlzYWJs
ZWQgX19yZWFkX21vc3RseTsKIAotI2RlZmluZSBNSVNDX01DRUxPR19NSU5PUgkyMjcKLQogI2Rl
ZmluZSBTUElOVU5JVCAxMDAJLyogMTAwbnMgKi8KIAogYXRvbWljX3QgbWNlX2VudHJ5OwpAQCAt
MjM0MSw3ICsyMzM5LDcgQEAgc3RhdGljIF9faW5pdCBpbnQgbWNoZWNrX2luaXRfZGV2aWNlKHZv
aWQpCiAKIAlyZXR1cm4gZXJyOwogfQotZGV2aWNlX2luaXRjYWxsKG1jaGVja19pbml0X2Rldmlj
ZSk7CitkZXZpY2VfaW5pdGNhbGxfc3luYyhtY2hlY2tfaW5pdF9kZXZpY2UpOwogCiAvKgogICog
T2xkIHN0eWxlIGJvb3Qgb3B0aW9ucyBwYXJzaW5nLiBPbmx5IGZvciBjb21wYXRpYmlsaXR5Lgpk
aWZmIC0tZ2l0IGEvYXJjaC94ODYveGVuL2VubGlnaHRlbi5jIGIvYXJjaC94ODYveGVuL2VubGln
aHRlbi5jCmluZGV4IDc1ZjMzYjIuLmZmMmQwMGUgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L3hlbi9l
bmxpZ2h0ZW4uYworKysgYi9hcmNoL3g4Ni94ZW4vZW5saWdodGVuLmMKQEAgLTM4LDYgKzM4LDcg
QEAKICNpbmNsdWRlIDx4ZW4vaW50ZXJmYWNlL3BoeXNkZXYuaD4KICNpbmNsdWRlIDx4ZW4vaW50
ZXJmYWNlL3ZjcHUuaD4KICNpbmNsdWRlIDx4ZW4vaW50ZXJmYWNlL21lbW9yeS5oPgorI2luY2x1
ZGUgPHhlbi9pbnRlcmZhY2UveGVuLW1jYS5oPgogI2luY2x1ZGUgPHhlbi9mZWF0dXJlcy5oPgog
I2luY2x1ZGUgPHhlbi9wYWdlLmg+CiAjaW5jbHVkZSA8eGVuL2h2bS5oPgpAQCAtMzMzLDkgKzMz
NCw3IEBAIHN0YXRpYyB2b2lkIF9faW5pdCB4ZW5faW5pdF9jcHVpZF9tYXNrKHZvaWQpCiAJdW5z
aWduZWQgaW50IHhzYXZlX21hc2s7CiAKIAljcHVpZF9sZWFmMV9lZHhfbWFzayA9Ci0JCX4oKDEg
PDwgWDg2X0ZFQVRVUkVfTUNFKSAgfCAgLyogZGlzYWJsZSBNQ0UgKi8KLQkJICAoMSA8PCBYODZf
RkVBVFVSRV9NQ0EpICB8ICAvKiBkaXNhYmxlIE1DQSAqLwotCQkgICgxIDw8IFg4Nl9GRUFUVVJF
X01UUlIpIHwgIC8qIGRpc2FibGUgTVRSUiAqLworCQl+KCgxIDw8IFg4Nl9GRUFUVVJFX01UUlIp
IHwgIC8qIGRpc2FibGUgTVRSUiAqLwogCQkgICgxIDw8IFg4Nl9GRUFUVVJFX0FDQykpOyAgIC8q
IHRoZXJtYWwgbW9uaXRvcmluZyAqLwogCiAJaWYgKCF4ZW5faW5pdGlhbF9kb21haW4oKSkKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMveGVuL0tjb25maWcgYi9kcml2ZXJzL3hlbi9LY29uZmlnCmluZGV4
IDhkMjUwMWUuLmQ0ZGZmY2QgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMveGVuL0tjb25maWcKKysrIGIv
ZHJpdmVycy94ZW4vS2NvbmZpZwpAQCAtMTk2LDQgKzE5NiwxMiBAQCBjb25maWcgWEVOX0FDUElf
UFJPQ0VTU09SCiAJICBjYWxsZWQgeGVuX2FjcGlfcHJvY2Vzc29yICBJZiB5b3UgZG8gbm90IGtu
b3cgd2hhdCB0byBjaG9vc2UsIHNlbGVjdAogCSAgTSBoZXJlLiBJZiB0aGUgQ1BVRlJFUSBkcml2
ZXJzIGFyZSBidWlsdCBpbiwgc2VsZWN0IFkgaGVyZS4KIAorY29uZmlnIFhFTl9NQ0VfTE9HCisJ
Ym9vbCAiWGVuIHBsYXRmb3JtIG1jZWxvZyIKKwlkZXBlbmRzIG9uIFhFTl9ET00wICYmIFg4Nl82
NCAmJiBYODZfTUNFCisJZGVmYXVsdCBuCisJaGVscAorCSAgQWxsb3cga2VybmVsIGZldGNoaW5n
IE1DRSBlcnJvciBmcm9tIFhlbiBwbGF0Zm9ybSBhbmQKKwkgIGNvbnZlcnRpbmcgaXQgaW50byBM
aW51eCBtY2Vsb2cgZm9ybWF0IGZvciBtY2Vsb2cgdG9vbHMKKwogZW5kbWVudQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy94ZW4vTWFrZWZpbGUgYi9kcml2ZXJzL3hlbi9NYWtlZmlsZQppbmRleCBmYzM0
ODg2Li5hNzg3MDI5IDEwMDY0NAotLS0gYS9kcml2ZXJzL3hlbi9NYWtlZmlsZQorKysgYi9kcml2
ZXJzL3hlbi9NYWtlZmlsZQpAQCAtMTgsNiArMTgsNyBAQCBvYmotJChDT05GSUdfWEVOX1BWSFZN
KQkJCSs9IHBsYXRmb3JtLXBjaS5vCiBvYmotJChDT05GSUdfWEVOX1RNRU0pCQkJKz0gdG1lbS5v
CiBvYmotJChDT05GSUdfU1dJT1RMQl9YRU4pCQkrPSBzd2lvdGxiLXhlbi5vCiBvYmotJChDT05G
SUdfWEVOX0RPTTApCQkJKz0gcGNpLm8gYWNwaS5vCitvYmotJChDT05GSUdfWEVOX01DRV9MT0cp
CQkrPSBtY2Vsb2cubwogb2JqLSQoQ09ORklHX1hFTl9QQ0lERVZfQkFDS0VORCkJKz0geGVuLXBj
aWJhY2svCiBvYmotJChDT05GSUdfWEVOX1BSSVZDTUQpCQkrPSB4ZW4tcHJpdmNtZC5vCiBvYmot
JChDT05GSUdfWEVOX0FDUElfUFJPQ0VTU09SKQkrPSB4ZW4tYWNwaS1wcm9jZXNzb3IubwpkaWZm
IC0tZ2l0IGEvZHJpdmVycy94ZW4vbWNlbG9nLmMgYi9kcml2ZXJzL3hlbi9tY2Vsb2cuYwpuZXcg
ZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwLi43MmU4N2QyCi0tLSAvZGV2L251bGwKKysr
IGIvZHJpdmVycy94ZW4vbWNlbG9nLmMKQEAgLTAsMCArMSwzOTIgQEAKKy8qKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioKKyAqIG1jZWxvZy5jCisgKiBEcml2ZXIgZm9yIHJlY2VpdmluZyBhbmQgdHJhbnNm
ZXJyaW5nIG1hY2hpbmUgY2hlY2sgZXJyb3IgaW5mb21hdGlvbgorICoKKyAqIENvcHlyaWdodCAo
YykgMjAxMiBJbnRlbCBDb3Jwb3JhdGlvbgorICogQXV0aG9yOiBMaXUsIEppbnNvbmcgPGppbnNv
bmcubGl1QGludGVsLmNvbT4KKyAqIEF1dGhvcjogSmlhbmcsIFl1bmhvbmcgPHl1bmhvbmcuamlh
bmdAaW50ZWwuY29tPgorICogQXV0aG9yOiBLZSwgTGlwaW5nIDxsaXBpbmcua2VAaW50ZWwuY29t
PgorICoKKyAqIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJp
YnV0ZSBpdCBhbmQvb3IKKyAqIG1vZGlmeSBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBH
ZW5lcmFsIFB1YmxpYyBMaWNlbnNlIHZlcnNpb24gMgorICogYXMgcHVibGlzaGVkIGJ5IHRoZSBG
cmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IG9yLCB3aGVuIGRpc3RyaWJ1dGVkCisgKiBzZXBhcmF0
ZWx5IGZyb20gdGhlIExpbnV4IGtlcm5lbCBvciBpbmNvcnBvcmF0ZWQgaW50byBvdGhlcgorICog
c29mdHdhcmUgcGFja2FnZXMsIHN1YmplY3QgdG8gdGhlIGZvbGxvd2luZyBsaWNlbnNlOgorICoK
KyAqIFBlcm1pc3Npb24gaXMgaGVyZWJ5IGdyYW50ZWQsIGZyZWUgb2YgY2hhcmdlLCB0byBhbnkg
cGVyc29uIG9idGFpbmluZyBhIGNvcHkKKyAqIG9mIHRoaXMgc291cmNlIGZpbGUgKHRoZSAiU29m
dHdhcmUiKSwgdG8gZGVhbCBpbiB0aGUgU29mdHdhcmUgd2l0aG91dAorICogcmVzdHJpY3Rpb24s
IGluY2x1ZGluZyB3aXRob3V0IGxpbWl0YXRpb24gdGhlIHJpZ2h0cyB0byB1c2UsIGNvcHksIG1v
ZGlmeSwKKyAqIG1lcmdlLCBwdWJsaXNoLCBkaXN0cmlidXRlLCBzdWJsaWNlbnNlLCBhbmQvb3Ig
c2VsbCBjb3BpZXMgb2YgdGhlIFNvZnR3YXJlLAorICogYW5kIHRvIHBlcm1pdCBwZXJzb25zIHRv
IHdob20gdGhlIFNvZnR3YXJlIGlzIGZ1cm5pc2hlZCB0byBkbyBzbywgc3ViamVjdCB0bworICog
dGhlIGZvbGxvd2luZyBjb25kaXRpb25zOgorICoKKyAqIFRoZSBhYm92ZSBjb3B5cmlnaHQgbm90
aWNlIGFuZCB0aGlzIHBlcm1pc3Npb24gbm90aWNlIHNoYWxsIGJlIGluY2x1ZGVkIGluCisgKiBh
bGwgY29waWVzIG9yIHN1YnN0YW50aWFsIHBvcnRpb25zIG9mIHRoZSBTb2Z0d2FyZS4KKyAqCisg
KiBUSEUgU09GVFdBUkUgSVMgUFJPVklERUQgIkFTIElTIiwgV0lUSE9VVCBXQVJSQU5UWSBPRiBB
TlkgS0lORCwgRVhQUkVTUyBPUgorICogSU1QTElFRCwgSU5DTFVESU5HIEJVVCBOT1QgTElNSVRF
RCBUTyBUSEUgV0FSUkFOVElFUyBPRiBNRVJDSEFOVEFCSUxJVFksCisgKiBGSVRORVNTIEZPUiBB
IFBBUlRJQ1VMQVIgUFVSUE9TRSBBTkQgTk9OSU5GUklOR0VNRU5ULiBJTiBOTyBFVkVOVCBTSEFM
TCBUSEUKKyAqIEFVVEhPUlMgT1IgQ09QWVJJR0hUIEhPTERFUlMgQkUgTElBQkxFIEZPUiBBTlkg
Q0xBSU0sIERBTUFHRVMgT1IgT1RIRVIKKyAqIExJQUJJTElUWSwgV0hFVEhFUiBJTiBBTiBBQ1RJ
T04gT0YgQ09OVFJBQ1QsIFRPUlQgT1IgT1RIRVJXSVNFLCBBUklTSU5HCisgKiBGUk9NLCBPVVQg
T0YgT1IgSU4gQ09OTkVDVElPTiBXSVRIIFRIRSBTT0ZUV0FSRSBPUiBUSEUgVVNFIE9SIE9USEVS
IERFQUxJTkdTCisgKiBJTiBUSEUgU09GVFdBUkUuCisgKi8KKworI2luY2x1ZGUgPGxpbnV4L2lu
aXQuaD4KKyNpbmNsdWRlIDxsaW51eC90eXBlcy5oPgorI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5o
PgorI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4KKyNpbmNsdWRlIDxsaW51eC9mcy5oPgorI2luY2x1
ZGUgPGxpbnV4L2RldmljZS5oPgorI2luY2x1ZGUgPGxpbnV4L21pc2NkZXZpY2UuaD4KKyNpbmNs
dWRlIDxsaW51eC91YWNjZXNzLmg+CisjaW5jbHVkZSA8bGludXgvY2FwYWJpbGl0eS5oPgorCisj
aW5jbHVkZSA8eGVuL2ludGVyZmFjZS94ZW4uaD4KKyNpbmNsdWRlIDx4ZW4vZXZlbnRzLmg+Cisj
aW5jbHVkZSA8eGVuL2ludGVyZmFjZS92Y3B1Lmg+CisjaW5jbHVkZSA8eGVuL3hlbi5oPgorI2lu
Y2x1ZGUgPGFzbS94ZW4vaHlwZXJjYWxsLmg+CisjaW5jbHVkZSA8YXNtL3hlbi9oeXBlcnZpc29y
Lmg+CisKKyNkZWZpbmUgWEVOX01DRUxPRyAieGVuX21jZWxvZzogIgorCitzdGF0aWMgc3RydWN0
IG1jX2luZm8gZ19taTsKK3N0YXRpYyBzdHJ1Y3QgbWNpbmZvX2xvZ2ljYWxfY3B1ICpnX3BoeXNp
bmZvOworc3RhdGljIHVpbnQzMl90IG5jcHVzOworCitzdGF0aWMgREVGSU5FX1NQSU5MT0NLKG1j
ZWxvZ19sb2NrKTsKKworc3RhdGljIHN0cnVjdCB4ZW5fbWNlX2xvZyB4ZW5fbWNlbG9nID0gewor
CS5zaWduYXR1cmUJPSBYRU5fTUNFX0xPR19TSUdOQVRVUkUsCisJLmxlbgkJPSBYRU5fTUNFX0xP
R19MRU4sCisJLnJlY29yZGxlbgk9IHNpemVvZihzdHJ1Y3QgeGVuX21jZSksCit9OworCitzdGF0
aWMgREVGSU5FX1NQSU5MT0NLKHhlbl9tY2VfY2hyZGV2X3N0YXRlX2xvY2spOworc3RhdGljIGlu
dCB4ZW5fbWNlX2NocmRldl9vcGVuX2NvdW50OwkvKiAjdGltZXMgb3BlbmVkICovCitzdGF0aWMg
aW50IHhlbl9tY2VfY2hyZGV2X29wZW5fZXhjbHU7CS8qIGFscmVhZHkgb3BlbiBleGNsdXNpdmU/
ICovCisKK3N0YXRpYyBpbnQgeGVuX21jZV9jaHJkZXZfb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2Rl
LCBzdHJ1Y3QgZmlsZSAqZmlsZSkKK3sKKwlzcGluX2xvY2soJnhlbl9tY2VfY2hyZGV2X3N0YXRl
X2xvY2spOworCisJaWYgKHhlbl9tY2VfY2hyZGV2X29wZW5fZXhjbHUgfHwKKwkgICAgKHhlbl9t
Y2VfY2hyZGV2X29wZW5fY291bnQgJiYgKGZpbGUtPmZfZmxhZ3MgJiBPX0VYQ0wpKSkgeworCQlz
cGluX3VubG9jaygmeGVuX21jZV9jaHJkZXZfc3RhdGVfbG9jayk7CisKKwkJcmV0dXJuIC1FQlVT
WTsKKwl9CisKKwlpZiAoZmlsZS0+Zl9mbGFncyAmIE9fRVhDTCkKKwkJeGVuX21jZV9jaHJkZXZf
b3Blbl9leGNsdSA9IDE7CisJeGVuX21jZV9jaHJkZXZfb3Blbl9jb3VudCsrOworCisJc3Bpbl91
bmxvY2soJnhlbl9tY2VfY2hyZGV2X3N0YXRlX2xvY2spOworCisJcmV0dXJuIG5vbnNlZWthYmxl
X29wZW4oaW5vZGUsIGZpbGUpOworfQorCitzdGF0aWMgaW50IHhlbl9tY2VfY2hyZGV2X3JlbGVh
c2Uoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpCit7CisJc3Bpbl9sb2Nr
KCZ4ZW5fbWNlX2NocmRldl9zdGF0ZV9sb2NrKTsKKworCXhlbl9tY2VfY2hyZGV2X29wZW5fY291
bnQtLTsKKwl4ZW5fbWNlX2NocmRldl9vcGVuX2V4Y2x1ID0gMDsKKworCXNwaW5fdW5sb2NrKCZ4
ZW5fbWNlX2NocmRldl9zdGF0ZV9sb2NrKTsKKworCXJldHVybiAwOworfQorCitzdGF0aWMgc3Np
emVfdCB4ZW5fbWNlX2NocmRldl9yZWFkKHN0cnVjdCBmaWxlICpmaWxwLCBjaGFyIF9fdXNlciAq
dWJ1ZiwKKwkJCQlzaXplX3QgdXNpemUsIGxvZmZfdCAqb2ZmKQoreworCWNoYXIgX191c2VyICpi
dWYgPSB1YnVmOworCXVuc2lnbmVkIG51bTsKKwlpbnQgaSwgZXJyOworCisJc3Bpbl9sb2NrKCZt
Y2Vsb2dfbG9jayk7CisKKwludW0gPSB4ZW5fbWNlbG9nLm5leHQ7CisKKwkvKiBPbmx5IHN1cHBv
cnRzIGZ1bGwgcmVhZHMgcmlnaHQgbm93ICovCisJZXJyID0gLUVJTlZBTDsKKwlpZiAoKm9mZiAh
PSAwIHx8IHVzaXplIDwgWEVOX01DRV9MT0dfTEVOKnNpemVvZihzdHJ1Y3QgeGVuX21jZSkpCisJ
CWdvdG8gb3V0OworCisJZXJyID0gMDsKKwlmb3IgKGkgPSAwOyBpIDwgbnVtOyBpKyspIHsKKwkJ
c3RydWN0IHhlbl9tY2UgKm0gPSAmeGVuX21jZWxvZy5lbnRyeVtpXTsKKworCQllcnIgfD0gY29w
eV90b191c2VyKGJ1ZiwgbSwgc2l6ZW9mKCptKSk7CisJCWJ1ZiArPSBzaXplb2YoKm0pOworCX0K
KworCW1lbXNldCh4ZW5fbWNlbG9nLmVudHJ5LCAwLCBudW0gKiBzaXplb2Yoc3RydWN0IHhlbl9t
Y2UpKTsKKwl4ZW5fbWNlbG9nLm5leHQgPSAwOworCisJaWYgKGVycikKKwkJZXJyID0gLUVGQVVM
VDsKKworb3V0OgorCXNwaW5fdW5sb2NrKCZtY2Vsb2dfbG9jayk7CisKKwlyZXR1cm4gZXJyID8g
ZXJyIDogYnVmIC0gdWJ1ZjsKK30KKworc3RhdGljIGxvbmcgeGVuX21jZV9jaHJkZXZfaW9jdGwo
c3RydWN0IGZpbGUgKmYsIHVuc2lnbmVkIGludCBjbWQsCisJCQkJdW5zaWduZWQgbG9uZyBhcmcp
Cit7CisJaW50IF9fdXNlciAqcCA9IChpbnQgX191c2VyICopYXJnOworCisJaWYgKCFjYXBhYmxl
KENBUF9TWVNfQURNSU4pKQorCQlyZXR1cm4gLUVQRVJNOworCisJc3dpdGNoIChjbWQpIHsKKwlj
YXNlIE1DRV9HRVRfUkVDT1JEX0xFTjoKKwkJcmV0dXJuIHB1dF91c2VyKHNpemVvZihzdHJ1Y3Qg
eGVuX21jZSksIHApOworCWNhc2UgTUNFX0dFVF9MT0dfTEVOOgorCQlyZXR1cm4gcHV0X3VzZXIo
WEVOX01DRV9MT0dfTEVOLCBwKTsKKwljYXNlIE1DRV9HRVRDTEVBUl9GTEFHUzogeworCQl1bnNp
Z25lZCBmbGFnczsKKworCQlkbyB7CisJCQlmbGFncyA9IHhlbl9tY2Vsb2cuZmxhZ3M7CisJCX0g
d2hpbGUgKGNtcHhjaGcoJnhlbl9tY2Vsb2cuZmxhZ3MsIGZsYWdzLCAwKSAhPSBmbGFncyk7CisK
KwkJcmV0dXJuIHB1dF91c2VyKGZsYWdzLCBwKTsKKwl9CisJZGVmYXVsdDoKKwkJcmV0dXJuIC1F
Tk9UVFk7CisJfQorfQorCitzdGF0aWMgY29uc3Qgc3RydWN0IGZpbGVfb3BlcmF0aW9ucyB4ZW5f
bWNlX2NocmRldl9vcHMgPSB7CisJLm9wZW4JCQk9IHhlbl9tY2VfY2hyZGV2X29wZW4sCisJLnJl
bGVhc2UJCT0geGVuX21jZV9jaHJkZXZfcmVsZWFzZSwKKwkucmVhZAkJCT0geGVuX21jZV9jaHJk
ZXZfcmVhZCwKKwkudW5sb2NrZWRfaW9jdGwJCT0geGVuX21jZV9jaHJkZXZfaW9jdGwsCisJLmxs
c2VlawkJCT0gbm9fbGxzZWVrLAorfTsKKworc3RhdGljIHN0cnVjdCBtaXNjZGV2aWNlIHhlbl9t
Y2VfY2hyZGV2X2RldmljZSA9IHsKKwlNSVNDX01DRUxPR19NSU5PUiwKKwkibWNlbG9nIiwKKwkm
eGVuX21jZV9jaHJkZXZfb3BzLAorfTsKKworLyoKKyAqIENhbGxlciBzaG91bGQgaG9sZCB0aGUg
bWNlbG9nX2xvY2sKKyAqLworc3RhdGljIHZvaWQgeGVuX21jZV9sb2coc3RydWN0IHhlbl9tY2Ug
Km1jZSkKK3sKKwl1bnNpZ25lZCBlbnRyeTsKKworCWVudHJ5ID0geGVuX21jZWxvZy5uZXh0Owor
CisJLyoKKwkgKiBXaGVuIHRoZSBidWZmZXIgZmlsbHMgdXAgZGlzY2FyZCBuZXcgZW50cmllcy4K
KwkgKiBBc3N1bWUgdGhhdCB0aGUgZWFybGllciBlcnJvcnMgYXJlIHRoZSBtb3JlCisJICogaW50
ZXJlc3Rpbmcgb25lczoKKwkgKi8KKwlpZiAoZW50cnkgPj0gWEVOX01DRV9MT0dfTEVOKSB7CisJ
CXNldF9iaXQoWEVOX01DRV9PVkVSRkxPVywKKwkJCSh1bnNpZ25lZCBsb25nICopJnhlbl9tY2Vs
b2cuZmxhZ3MpOworCQlyZXR1cm47CisJfQorCisJbWVtY3B5KHhlbl9tY2Vsb2cuZW50cnkgKyBl
bnRyeSwgbWNlLCBzaXplb2Yoc3RydWN0IHhlbl9tY2UpKTsKKworCXhlbl9tY2Vsb2cubmV4dCsr
OworfQorCitzdGF0aWMgaW50IGNvbnZlcnRfbG9nKHN0cnVjdCBtY19pbmZvICptaSkKK3sKKwlz
dHJ1Y3QgbWNpbmZvX2NvbW1vbiAqbWljOworCXN0cnVjdCBtY2luZm9fZ2xvYmFsICptY19nbG9i
YWw7CisJc3RydWN0IG1jaW5mb19iYW5rICptY19iYW5rOworCXN0cnVjdCB4ZW5fbWNlIG07CisJ
dWludDMyX3QgaTsKKworCW1pYyA9IE5VTEw7CisJeDg2X21jaW5mb19sb29rdXAoJm1pYywgbWks
IE1DX1RZUEVfR0xPQkFMKTsKKwlpZiAodW5saWtlbHkoIW1pYykpIHsKKwkJcHJfd2FybmluZyhY
RU5fTUNFTE9HICJGYWlsZWQgdG8gZmluZCBnbG9iYWwgZXJyb3IgaW5mb1xuIik7CisJCXJldHVy
biAtRU5PREVWOworCX0KKworCW1lbXNldCgmbSwgMCwgc2l6ZW9mKHN0cnVjdCB4ZW5fbWNlKSk7
CisKKwltY19nbG9iYWwgPSAoc3RydWN0IG1jaW5mb19nbG9iYWwgKiltaWM7CisJbS5tY2dzdGF0
dXMgPSBtY19nbG9iYWwtPm1jX2dzdGF0dXM7CisJbS5hcGljaWQgPSBtY19nbG9iYWwtPm1jX2Fw
aWNpZDsKKworCWZvciAoaSA9IDA7IGkgPCBuY3B1czsgaSsrKQorCQlpZiAoZ19waHlzaW5mb1tp
XS5tY19hcGljaWQgPT0gbS5hcGljaWQpCisJCQlicmVhazsKKwlpZiAodW5saWtlbHkoaSA9PSBu
Y3B1cykpIHsKKwkJcHJfd2FybmluZyhYRU5fTUNFTE9HICJGYWlsZWQgdG8gbWF0Y2ggY3B1IHdp
dGggYXBpY2lkICVkXG4iLAorCQkJICAgbS5hcGljaWQpOworCQlyZXR1cm4gLUVOT0RFVjsKKwl9
CisKKwltLnNvY2tldGlkID0gZ19waHlzaW5mb1tpXS5tY19jaGlwaWQ7CisJbS5jcHUgPSBtLmV4
dGNwdSA9IGdfcGh5c2luZm9baV0ubWNfY3B1bnI7CisJbS5jcHV2ZW5kb3IgPSAoX191OClnX3Bo
eXNpbmZvW2ldLm1jX3ZlbmRvcjsKKwltLm1jZ2NhcCA9IGdfcGh5c2luZm9baV0ubWNfbXNydmFs
dWVzW19fTUNfTVNSX01DR0NBUF0udmFsdWU7CisKKwltaWMgPSBOVUxMOworCXg4Nl9tY2luZm9f
bG9va3VwKCZtaWMsIG1pLCBNQ19UWVBFX0JBTkspOworCWlmICh1bmxpa2VseSghbWljKSkgewor
CQlwcl93YXJuaW5nKFhFTl9NQ0VMT0cgIkZhaWwgdG8gZmluZCBiYW5rIGVycm9yIGluZm9cbiIp
OworCQlyZXR1cm4gLUVOT0RFVjsKKwl9CisKKwlkbyB7CisJCWlmICgoIW1pYykgfHwgKG1pYy0+
c2l6ZSA9PSAwKSB8fAorCQkgICAgKG1pYy0+dHlwZSAhPSBNQ19UWVBFX0dMT0JBTCAgICYmCisJ
CSAgICAgbWljLT50eXBlICE9IE1DX1RZUEVfQkFOSyAgICAgJiYKKwkJICAgICBtaWMtPnR5cGUg
IT0gTUNfVFlQRV9FWFRFTkRFRCAmJgorCQkgICAgIG1pYy0+dHlwZSAhPSBNQ19UWVBFX1JFQ09W
RVJZKSkKKwkJCWJyZWFrOworCisJCWlmIChtaWMtPnR5cGUgPT0gTUNfVFlQRV9CQU5LKSB7CisJ
CQltY19iYW5rID0gKHN0cnVjdCBtY2luZm9fYmFuayAqKW1pYzsKKwkJCW0ubWlzYyA9IG1jX2Jh
bmstPm1jX21pc2M7CisJCQltLnN0YXR1cyA9IG1jX2JhbmstPm1jX3N0YXR1czsKKwkJCW0uYWRk
ciA9IG1jX2JhbmstPm1jX2FkZHI7CisJCQltLnRzYyA9IG1jX2JhbmstPm1jX3RzYzsKKwkJCW0u
YmFuayA9IG1jX2JhbmstPm1jX2Jhbms7CisJCQltLmZpbmlzaGVkID0gMTsKKwkJCS8qbG9nIHRo
aXMgcmVjb3JkKi8KKwkJCXhlbl9tY2VfbG9nKCZtKTsKKwkJfQorCQltaWMgPSB4ODZfbWNpbmZv
X25leHQobWljKTsKKwl9IHdoaWxlICgxKTsKKworCXJldHVybiAwOworfQorCitzdGF0aWMgaW50
IG1jX3F1ZXVlX2hhbmRsZSh1aW50MzJfdCBmbGFncykKK3sKKwlzdHJ1Y3QgeGVuX21jIG1jX29w
OworCWludCByZXQgPSAwOworCisJbWNfb3AuY21kID0gWEVOX01DX2ZldGNoOworCW1jX29wLmlu
dGVyZmFjZV92ZXJzaW9uID0gWEVOX01DQV9JTlRFUkZBQ0VfVkVSU0lPTjsKKwlzZXRfeGVuX2d1
ZXN0X2hhbmRsZShtY19vcC51Lm1jX2ZldGNoLmRhdGEsICZnX21pKTsKKwlkbyB7CisJCW1jX29w
LnUubWNfZmV0Y2guZmxhZ3MgPSBmbGFnczsKKwkJcmV0ID0gSFlQRVJWSVNPUl9tY2EoJm1jX29w
KTsKKwkJaWYgKHJldCkgeworCQkJcHJfZXJyKFhFTl9NQ0VMT0cgIkZhaWxlZCB0byBmZXRjaCAl
cyBlcnJvciBsb2dcbiIsCisJCQkgICAgICAgKGZsYWdzID09IFhFTl9NQ19VUkdFTlQpID8KKwkJ
CSAgICAgICAidXJnbmV0IiA6ICJub251cmdlbnQiKTsKKwkJCWJyZWFrOworCQl9CisKKwkJaWYg
KG1jX29wLnUubWNfZmV0Y2guZmxhZ3MgJiBYRU5fTUNfTk9EQVRBIHx8CisJCSAgICBtY19vcC51
Lm1jX2ZldGNoLmZsYWdzICYgWEVOX01DX0ZFVENIRkFJTEVEKQorCQkJYnJlYWs7CisJCWVsc2Ug
eworCQkJcmV0ID0gY29udmVydF9sb2coJmdfbWkpOworCQkJaWYgKHJldCkKKwkJCQlwcl93YXJu
aW5nKFhFTl9NQ0VMT0cKKwkJCQkJICAgIkZhaWxlZCB0byBjb252ZXJ0IHRoaXMgZXJyb3IgbG9n
LCAiCisJCQkJCSAgICJjb250aW51ZSBhY2tpbmcgaXQgYW55d2F5XG4iKTsKKworCQkJbWNfb3Au
dS5tY19mZXRjaC5mbGFncyA9IGZsYWdzIHwgWEVOX01DX0FDSzsKKwkJCXJldCA9IEhZUEVSVklT
T1JfbWNhKCZtY19vcCk7CisJCQlpZiAocmV0KSB7CisJCQkJcHJfZXJyKFhFTl9NQ0VMT0cKKwkJ
CQkgICAgICAgIkZhaWxlZCB0byBhY2sgcHJldmlvdXMgZXJyb3IgbG9nXG4iKTsKKwkJCQlicmVh
azsKKwkJCX0KKwkJfQorCX0gd2hpbGUgKDEpOworCisJcmV0dXJuIHJldDsKK30KKworLyogdmly
cSBoYW5kbGVyIGZvciBtYWNoaW5lIGNoZWNrIGVycm9yIGluZm8qLworc3RhdGljIGlycXJldHVy
bl90IHhlbl9tY2VfaW50ZXJydXB0KGludCBpcnEsIHZvaWQgKmRldl9pZCkKK3sKKwlpbnQgZXJy
OworCXVuc2lnbmVkIGxvbmcgdG1wOworCisJc3Bpbl9sb2NrX2lycXNhdmUoJm1jZWxvZ19sb2Nr
LCB0bXApOworCisJLyogdXJnZW50IG1jX2luZm8gKi8KKwllcnIgPSBtY19xdWV1ZV9oYW5kbGUo
WEVOX01DX1VSR0VOVCk7CisJaWYgKGVycikKKwkJcHJfZXJyKFhFTl9NQ0VMT0cKKwkJICAgICAg
ICJGYWlsZWQgdG8gaGFuZGxlIHVyZ2VudCBtY19pbmZvIHF1ZXVlLCAiCisJCSAgICAgICAiY29u
dGludWUgaGFuZGxpbmcgbm9udXJnZW50IG1jX2luZm8gcXVldWUgYW55d2F5LlxuIik7CisKKwkv
KiBub251cmdlbnQgbWNfaW5mbyAqLworCWVyciA9IG1jX3F1ZXVlX2hhbmRsZShYRU5fTUNfTk9O
VVJHRU5UKTsKKwlpZiAoZXJyKQorCQlwcl9lcnIoWEVOX01DRUxPRworCQkgICAgICAgIkZhaWxl
ZCB0byBoYW5kbGUgbm9udXJnZW50IG1jX2luZm8gcXVldWUuXG4iKTsKKworCXNwaW5fdW5sb2Nr
X2lycXJlc3RvcmUoJm1jZWxvZ19sb2NrLCB0bXApOworCisJcmV0dXJuIElSUV9IQU5ETEVEOwor
fQorCitzdGF0aWMgaW50IGJpbmRfdmlycV9mb3JfbWNlKHZvaWQpCit7CisJaW50IHJldDsKKwlz
dHJ1Y3QgeGVuX21jIG1jX29wOworCisJbWVtc2V0KCZtY19vcCwgMCwgc2l6ZW9mKHN0cnVjdCB4
ZW5fbWMpKTsKKworCS8qIEZldGNoIHBoeXNpY2FsIENQVSBOdW1iZXJzICovCisJbWNfb3AuY21k
ID0gWEVOX01DX3BoeXNjcHVpbmZvOworCW1jX29wLmludGVyZmFjZV92ZXJzaW9uID0gWEVOX01D
QV9JTlRFUkZBQ0VfVkVSU0lPTjsKKwlzZXRfeGVuX2d1ZXN0X2hhbmRsZShtY19vcC51Lm1jX3Bo
eXNjcHVpbmZvLmluZm8sIGdfcGh5c2luZm8pOworCXJldCA9IEhZUEVSVklTT1JfbWNhKCZtY19v
cCk7CisJaWYgKHJldCkgeworCQlwcl9lcnIoWEVOX01DRUxPRyAiRmFpbGVkIHRvIGdldCBDUFUg
bnVtYmVyc1xuIik7CisJCXJldHVybiByZXQ7CisJfQorCisJLyogRmV0Y2ggZWFjaCBDUFUgUGh5
c2ljYWwgSW5mbyBmb3IgbGF0ZXIgcmVmZXJlbmNlKi8KKwluY3B1cyA9IG1jX29wLnUubWNfcGh5
c2NwdWluZm8ubmNwdXM7CisJZ19waHlzaW5mbyA9IGtjYWxsb2MobmNwdXMsIHNpemVvZihzdHJ1
Y3QgbWNpbmZvX2xvZ2ljYWxfY3B1KSwKKwkJCSAgICAgR0ZQX0tFUk5FTCk7CisJaWYgKCFnX3Bo
eXNpbmZvKQorCQlyZXR1cm4gLUVOT01FTTsKKwlzZXRfeGVuX2d1ZXN0X2hhbmRsZShtY19vcC51
Lm1jX3BoeXNjcHVpbmZvLmluZm8sIGdfcGh5c2luZm8pOworCXJldCA9IEhZUEVSVklTT1JfbWNh
KCZtY19vcCk7CisJaWYgKHJldCkgeworCQlwcl9lcnIoWEVOX01DRUxPRyAiRmFpbGVkIHRvIGdl
dCBDUFUgaW5mb1xuIik7CisJCWtmcmVlKGdfcGh5c2luZm8pOworCQlyZXR1cm4gcmV0OworCX0K
KworCXJldCAgPSBiaW5kX3ZpcnFfdG9faXJxaGFuZGxlcihWSVJRX01DQSwgMCwKKwkJCQkgICAg
ICAgeGVuX21jZV9pbnRlcnJ1cHQsIDAsICJtY2UiLCBOVUxMKTsKKwlpZiAocmV0IDwgMCkgewor
CQlwcl9lcnIoWEVOX01DRUxPRyAiRmFpbGVkIHRvIGJpbmQgdmlycVxuIik7CisJCWtmcmVlKGdf
cGh5c2luZm8pOworCQlyZXR1cm4gcmV0OworCX0KKworCXJldHVybiAwOworfQorCitzdGF0aWMg
aW50IF9faW5pdCB4ZW5fbGF0ZV9pbml0X21jZWxvZyh2b2lkKQoreworCS8qIE9ubHkgRE9NMCBp
cyByZXNwb25zaWJsZSBmb3IgTUNFIGxvZ2dpbmcgKi8KKwlpZiAoeGVuX2luaXRpYWxfZG9tYWlu
KCkpIHsKKwkJLyogcmVnaXN0ZXIgY2hhcmFjdGVyIGRldmljZSAvZGV2L21jZWxvZyBmb3IgeGVu
IG1jZWxvZyAqLworCQlpZiAobWlzY19yZWdpc3RlcigmeGVuX21jZV9jaHJkZXZfZGV2aWNlKSkK
KwkJCXJldHVybiAtRU5PREVWOworCQlyZXR1cm4gYmluZF92aXJxX2Zvcl9tY2UoKTsKKwl9CisK
KwlyZXR1cm4gLUVOT0RFVjsKK30KK2RldmljZV9pbml0Y2FsbCh4ZW5fbGF0ZV9pbml0X21jZWxv
Zyk7CmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L21pc2NkZXZpY2UuaCBiL2luY2x1ZGUvbGlu
dXgvbWlzY2RldmljZS5oCmluZGV4IDA1NDlkMjEuLmUwZGVlYjIgMTAwNjQ0Ci0tLSBhL2luY2x1
ZGUvbGludXgvbWlzY2RldmljZS5oCisrKyBiL2luY2x1ZGUvbGludXgvbWlzY2RldmljZS5oCkBA
IC0zNSw2ICszNSw3IEBACiAjZGVmaW5lIE1QVF9NSU5PUgkJMjIwCiAjZGVmaW5lIE1QVDJTQVNf
TUlOT1IJCTIyMQogI2RlZmluZSBVSU5QVVRfTUlOT1IJCTIyMworI2RlZmluZSBNSVNDX01DRUxP
R19NSU5PUgkyMjcKICNkZWZpbmUgSFBFVF9NSU5PUgkJMjI4CiAjZGVmaW5lIEZVU0VfTUlOT1IJ
CTIyOQogI2RlZmluZSBLVk1fTUlOT1IJCTIzMgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS94ZW4vaW50
ZXJmYWNlL3hlbi1tY2EuaCBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS94ZW4tbWNhLmgKbmV3IGZp
bGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uNzNhNGVhNwotLS0gL2Rldi9udWxsCisrKyBi
L2luY2x1ZGUveGVuL2ludGVyZmFjZS94ZW4tbWNhLmgKQEAgLTAsMCArMSwzODUgQEAKKy8qKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioKKyAqIGFyY2gteDg2L21jYS5oCisgKiBHdWVzdCBPUyBtYWNoaW5l
IGNoZWNrIGludGVyZmFjZSB0byB4ODYgWGVuLgorICoKKyAqIENvbnRyaWJ1dGVkIGJ5IEFkdmFu
Y2VkIE1pY3JvIERldmljZXMsIEluYy4KKyAqIEF1dGhvcjogQ2hyaXN0b3BoIEVnZ2VyIDxDaHJp
c3RvcGguRWdnZXJAYW1kLmNvbT4KKyAqCisgKiBVcGRhdGVkIGJ5IEludGVsIENvcnBvcmF0aW9u
CisgKiBBdXRob3I6IExpdSwgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgorICoKKyAq
IFBlcm1pc3Npb24gaXMgaGVyZWJ5IGdyYW50ZWQsIGZyZWUgb2YgY2hhcmdlLCB0byBhbnkgcGVy
c29uIG9idGFpbmluZyBhIGNvcHkKKyAqIG9mIHRoaXMgc29mdHdhcmUgYW5kIGFzc29jaWF0ZWQg
ZG9jdW1lbnRhdGlvbiBmaWxlcyAodGhlICJTb2Z0d2FyZSIpLCB0bworICogZGVhbCBpbiB0aGUg
U29mdHdhcmUgd2l0aG91dCByZXN0cmljdGlvbiwgaW5jbHVkaW5nIHdpdGhvdXQgbGltaXRhdGlv
biB0aGUKKyAqIHJpZ2h0cyB0byB1c2UsIGNvcHksIG1vZGlmeSwgbWVyZ2UsIHB1Ymxpc2gsIGRp
c3RyaWJ1dGUsIHN1YmxpY2Vuc2UsIGFuZC9vcgorICogc2VsbCBjb3BpZXMgb2YgdGhlIFNvZnR3
YXJlLCBhbmQgdG8gcGVybWl0IHBlcnNvbnMgdG8gd2hvbSB0aGUgU29mdHdhcmUgaXMKKyAqIGZ1
cm5pc2hlZCB0byBkbyBzbywgc3ViamVjdCB0byB0aGUgZm9sbG93aW5nIGNvbmRpdGlvbnM6Cisg
KgorICogVGhlIGFib3ZlIGNvcHlyaWdodCBub3RpY2UgYW5kIHRoaXMgcGVybWlzc2lvbiBub3Rp
Y2Ugc2hhbGwgYmUgaW5jbHVkZWQgaW4KKyAqIGFsbCBjb3BpZXMgb3Igc3Vic3RhbnRpYWwgcG9y
dGlvbnMgb2YgdGhlIFNvZnR3YXJlLgorICoKKyAqIFRIRSBTT0ZUV0FSRSBJUyBQUk9WSURFRCAi
QVMgSVMiLCBXSVRIT1VUIFdBUlJBTlRZIE9GIEFOWSBLSU5ELCBFWFBSRVNTIE9SCisgKiBJTVBM
SUVELCBJTkNMVURJTkcgQlVUIE5PVCBMSU1JVEVEIFRPIFRIRSBXQVJSQU5USUVTIE9GIE1FUkNI
QU5UQUJJTElUWSwKKyAqIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFIEFORCBOT05J
TkZSSU5HRU1FTlQuIElOIE5PIEVWRU5UIFNIQUxMIFRIRQorICogQVVUSE9SUyBPUiBDT1BZUklH
SFQgSE9MREVSUyBCRSBMSUFCTEUgRk9SIEFOWSBDTEFJTSwgREFNQUdFUyBPUiBPVEhFUgorICog
TElBQklMSVRZLCBXSEVUSEVSIElOIEFOIEFDVElPTiBPRiBDT05UUkFDVCwgVE9SVCBPUiBPVEhF
UldJU0UsIEFSSVNJTkcKKyAqIEZST00sIE9VVCBPRiBPUiBJTiBDT05ORUNUSU9OIFdJVEggVEhF
IFNPRlRXQVJFIE9SIFRIRSBVU0UgT1IgT1RIRVIKKyAqIERFQUxJTkdTIElOIFRIRSBTT0ZUV0FS
RS4KKyAqLworCisjaWZuZGVmIF9fWEVOX1BVQkxJQ19BUkNIX1g4Nl9NQ0FfSF9fCisjZGVmaW5l
IF9fWEVOX1BVQkxJQ19BUkNIX1g4Nl9NQ0FfSF9fCisKKy8qIEh5cGVyY2FsbCAqLworI2RlZmlu
ZSBfX0hZUEVSVklTT1JfbWNhIF9fSFlQRVJWSVNPUl9hcmNoXzAKKworI2RlZmluZSBYRU5fTUNB
X0lOVEVSRkFDRV9WRVJTSU9OCTB4MDFlY2MwMDMKKworLyogSU46IERvbTAgY2FsbHMgaHlwZXJj
YWxsIHRvIHJldHJpZXZlIG5vbnVyZ2VudCBlcnJvciBsb2cgZW50cnkgKi8KKyNkZWZpbmUgWEVO
X01DX05PTlVSR0VOVAkweDEKKy8qIElOOiBEb20wIGNhbGxzIGh5cGVyY2FsbCB0byByZXRyaWV2
ZSB1cmdlbnQgZXJyb3IgbG9nIGVudHJ5ICovCisjZGVmaW5lIFhFTl9NQ19VUkdFTlQJCTB4Mgor
LyogSU46IERvbTAgYWNrbm93bGVkZ2VzIHByZXZpb3NseS1mZXRjaGVkIGVycm9yIGxvZyBlbnRy
eSAqLworI2RlZmluZSBYRU5fTUNfQUNLCQkweDQKKworLyogT1VUOiBBbGwgaXMgb2sgKi8KKyNk
ZWZpbmUgWEVOX01DX09LCQkweDAKKy8qIE9VVDogRG9tYWluIGNvdWxkIG5vdCBmZXRjaCBkYXRh
LiAqLworI2RlZmluZSBYRU5fTUNfRkVUQ0hGQUlMRUQJMHgxCisvKiBPVVQ6IFRoZXJlIHdhcyBu
byBtYWNoaW5lIGNoZWNrIGRhdGEgdG8gZmV0Y2guICovCisjZGVmaW5lIFhFTl9NQ19OT0RBVEEJ
CTB4MgorCisjaWZuZGVmIF9fQVNTRU1CTFlfXworLyogdklSUSBpbmplY3RlZCB0byBEb20wICov
CisjZGVmaW5lIFZJUlFfTUNBIFZJUlFfQVJDSF8wCisKKy8qCisgKiBtY19pbmZvIGVudHJ5IHR5
cGVzCisgKiBtY2EgbWFjaGluZSBjaGVjayBpbmZvIGFyZSByZWNvcmRlZCBpbiBtY19pbmZvIGVu
dHJpZXMuCisgKiB3aGVuIGZldGNoIG1jYSBpbmZvLCBpdCBjYW4gdXNlIE1DX1RZUEVfLi4uIHRv
IGRpc3Rpbmd1aXNoCisgKiBkaWZmZXJlbnQgbWNhIGluZm8uCisgKi8KKyNkZWZpbmUgTUNfVFlQ
RV9HTE9CQUwJCTAKKyNkZWZpbmUgTUNfVFlQRV9CQU5LCQkxCisjZGVmaW5lIE1DX1RZUEVfRVhU
RU5ERUQJMgorI2RlZmluZSBNQ19UWVBFX1JFQ09WRVJZCTMKKworc3RydWN0IG1jaW5mb19jb21t
b24geworCXVpbnQxNl90IHR5cGU7IC8qIHN0cnVjdHVyZSB0eXBlICovCisJdWludDE2X3Qgc2l6
ZTsgLyogc2l6ZSBvZiB0aGlzIHN0cnVjdCBpbiBieXRlcyAqLworfTsKKworI2RlZmluZSBNQ19G
TEFHX0NPUlJFQ1RBQkxFCSgxIDw8IDApCisjZGVmaW5lIE1DX0ZMQUdfVU5DT1JSRUNUQUJMRQko
MSA8PCAxKQorI2RlZmluZSBNQ19GTEFHX1JFQ09WRVJBQkxFCSgxIDw8IDIpCisjZGVmaW5lIE1D
X0ZMQUdfUE9MTEVECQkoMSA8PCAzKQorI2RlZmluZSBNQ19GTEFHX1JFU0VUCQkoMSA8PCA0KQor
I2RlZmluZSBNQ19GTEFHX0NNQ0kJCSgxIDw8IDUpCisjZGVmaW5lIE1DX0ZMQUdfTUNFCQkoMSA8
PCA2KQorCisvKiBjb250YWlucyB4ODYgZ2xvYmFsIG1jIGluZm9ybWF0aW9uICovCitzdHJ1Y3Qg
bWNpbmZvX2dsb2JhbCB7CisJc3RydWN0IG1jaW5mb19jb21tb24gY29tbW9uOworCisJdWludDE2
X3QgbWNfZG9taWQ7IC8qIHJ1bm5pbmcgZG9tYWluIGF0IHRoZSB0aW1lIGluIGVycm9yICovCisJ
dWludDE2X3QgbWNfdmNwdWlkOyAvKiB2aXJ0dWFsIGNwdSBzY2hlZHVsZWQgZm9yIG1jX2RvbWlk
ICovCisJdWludDMyX3QgbWNfc29ja2V0aWQ7IC8qIHBoeXNpY2FsIHNvY2tldCBvZiB0aGUgcGh5
c2ljYWwgY29yZSAqLworCXVpbnQxNl90IG1jX2NvcmVpZDsgLyogcGh5c2ljYWwgaW1wYWN0ZWQg
Y29yZSAqLworCXVpbnQxNl90IG1jX2NvcmVfdGhyZWFkaWQ7IC8qIGNvcmUgdGhyZWFkIG9mIHBo
eXNpY2FsIGNvcmUgKi8KKwl1aW50MzJfdCBtY19hcGljaWQ7CisJdWludDMyX3QgbWNfZmxhZ3M7
CisJdWludDY0X3QgbWNfZ3N0YXR1czsgLyogZ2xvYmFsIHN0YXR1cyAqLworfTsKKworLyogY29u
dGFpbnMgeDg2IGJhbmsgbWMgaW5mb3JtYXRpb24gKi8KK3N0cnVjdCBtY2luZm9fYmFuayB7CisJ
c3RydWN0IG1jaW5mb19jb21tb24gY29tbW9uOworCisJdWludDE2X3QgbWNfYmFuazsgLyogYmFu
ayBuciAqLworCXVpbnQxNl90IG1jX2RvbWlkOyAvKiBkb21haW4gcmVmZXJlbmNlZCBieSBtY19h
ZGRyIGlmIHZhbGlkICovCisJdWludDY0X3QgbWNfc3RhdHVzOyAvKiBiYW5rIHN0YXR1cyAqLwor
CXVpbnQ2NF90IG1jX2FkZHI7IC8qIGJhbmsgYWRkcmVzcyAqLworCXVpbnQ2NF90IG1jX21pc2M7
CisJdWludDY0X3QgbWNfY3RybDI7CisJdWludDY0X3QgbWNfdHNjOworfTsKKworc3RydWN0IG1j
aW5mb19tc3IgeworCXVpbnQ2NF90IHJlZzsgLyogTVNSICovCisJdWludDY0X3QgdmFsdWU7IC8q
IE1TUiB2YWx1ZSAqLworfTsKKworLyogY29udGFpbnMgbWMgaW5mb3JtYXRpb24gZnJvbSBvdGhl
ciBvciBhZGRpdGlvbmFsIG1jIE1TUnMgKi8KK3N0cnVjdCBtY2luZm9fZXh0ZW5kZWQgeworCXN0
cnVjdCBtY2luZm9fY29tbW9uIGNvbW1vbjsKKwl1aW50MzJfdCBtY19tc3JzOyAvKiBOdW1iZXIg
b2YgbXNyIHdpdGggdmFsaWQgdmFsdWVzLiAqLworCS8qCisJICogQ3VycmVudGx5IEludGVsIGV4
dGVuZGVkIE1TUiAoMzIvNjQpIGluY2x1ZGUgYWxsIGdwIHJlZ2lzdGVycworCSAqIGFuZCBFKFIp
RkxBR1MsIEUoUilJUCwgRShSKU1JU0MsIHVwIHRvIDExLzE5IG9mIHRoZW0gbWlnaHQgYmUKKwkg
KiB1c2VmdWwgYXQgcHJlc2VudC4gU28gZXhwYW5kIHRoaXMgYXJyYXkgdG8gMTYvMzIgdG8gbGVh
dmUgcm9vbS4KKwkgKi8KKwlzdHJ1Y3QgbWNpbmZvX21zciBtY19tc3Jbc2l6ZW9mKHZvaWQgKikg
KiA0XTsKK307CisKKy8qIFJlY292ZXJ5IEFjdGlvbiBmbGFncy4gR2l2aW5nIHJlY292ZXJ5IHJl
c3VsdCBpbmZvcm1hdGlvbiB0byBET00wICovCisKKy8qIFhlbiB0YWtlcyBzdWNjZXNzZnVsIHJl
Y292ZXJ5IGFjdGlvbiwgdGhlIGVycm9yIGlzIHJlY292ZXJlZCAqLworI2RlZmluZSBSRUNfQUNU
SU9OX1JFQ09WRVJFRCAoMHgxIDw8IDApCisvKiBObyBhY3Rpb24gaXMgcGVyZm9ybWVkIGJ5IFhF
TiAqLworI2RlZmluZSBSRUNfQUNUSU9OX05PTkUgKDB4MSA8PCAxKQorLyogSXQncyBwb3NzaWJs
ZSBET00wIG1pZ2h0IHRha2UgYWN0aW9uIG93bmVyc2hpcCBpbiBzb21lIGNhc2UgKi8KKyNkZWZp
bmUgUkVDX0FDVElPTl9ORUVEX1JFU0VUICgweDEgPDwgMikKKworLyoKKyAqIERpZmZlcmVudCBS
ZWNvdmVyeSBBY3Rpb24gdHlwZXMsIGlmIHRoZSBhY3Rpb24gaXMgcGVyZm9ybWVkIHN1Y2Nlc3Nm
dWxseSwKKyAqIFJFQ19BQ1RJT05fUkVDT1ZFUkVEIGZsYWcgd2lsbCBiZSByZXR1cm5lZC4KKyAq
LworCisvKiBQYWdlIE9mZmxpbmUgQWN0aW9uICovCisjZGVmaW5lIE1DX0FDVElPTl9QQUdFX09G
RkxJTkUgKDB4MSA8PCAwKQorLyogQ1BVIG9mZmxpbmUgQWN0aW9uICovCisjZGVmaW5lIE1DX0FD
VElPTl9DUFVfT0ZGTElORSAoMHgxIDw8IDEpCisvKiBMMyBjYWNoZSBkaXNhYmxlIEFjdGlvbiAq
LworI2RlZmluZSBNQ19BQ1RJT05fQ0FDSEVfU0hSSU5LICgweDEgPDwgMikKKworLyoKKyAqIEJl
bG93IGludGVyZmFjZSB1c2VkIGJldHdlZW4gWEVOL0RPTTAgZm9yIHBhc3NpbmcgWEVOJ3MgcmVj
b3ZlcnkgYWN0aW9uCisgKiBpbmZvcm1hdGlvbiB0byBET00wLgorICovCitzdHJ1Y3QgcGFnZV9v
ZmZsaW5lX2FjdGlvbiB7CisJLyogUGFyYW1zIGZvciBwYXNzaW5nIHRoZSBvZmZsaW5lZCBwYWdl
IG51bWJlciB0byBET00wICovCisJdWludDY0X3QgbWZuOworCXVpbnQ2NF90IHN0YXR1czsKK307
CisKK3N0cnVjdCBjcHVfb2ZmbGluZV9hY3Rpb24geworCS8qIFBhcmFtcyBmb3IgcGFzc2luZyB0
aGUgaWRlbnRpdHkgb2YgdGhlIG9mZmxpbmVkIENQVSB0byBET00wICovCisJdWludDMyX3QgbWNf
c29ja2V0aWQ7CisJdWludDE2X3QgbWNfY29yZWlkOworCXVpbnQxNl90IG1jX2NvcmVfdGhyZWFk
aWQ7Cit9OworCisjZGVmaW5lIE1BWF9VTklPTl9TSVpFIDE2CitzdHJ1Y3QgbWNpbmZvX3JlY292
ZXJ5IHsKKwlzdHJ1Y3QgbWNpbmZvX2NvbW1vbiBjb21tb247CisJdWludDE2X3QgbWNfYmFuazsg
LyogYmFuayBuciAqLworCXVpbnQ4X3QgYWN0aW9uX2ZsYWdzOworCXVpbnQ4X3QgYWN0aW9uX3R5
cGVzOworCXVuaW9uIHsKKwkJc3RydWN0IHBhZ2Vfb2ZmbGluZV9hY3Rpb24gcGFnZV9yZXRpcmU7
CisJCXN0cnVjdCBjcHVfb2ZmbGluZV9hY3Rpb24gY3B1X29mZmxpbmU7CisJCXVpbnQ4X3QgcGFk
W01BWF9VTklPTl9TSVpFXTsKKwl9IGFjdGlvbl9pbmZvOworfTsKKworCisjZGVmaW5lIE1DSU5G
T19NQVhTSVpFIDc2OAorc3RydWN0IG1jX2luZm8geworCS8qIE51bWJlciBvZiBtY2luZm9fKiBl
bnRyaWVzIGluIG1pX2RhdGEgKi8KKwl1aW50MzJfdCBtaV9uZW50cmllczsKKwl1aW50MzJfdCBm
bGFnczsKKwl1aW50NjRfdCBtaV9kYXRhWyhNQ0lORk9fTUFYU0laRSAtIDEpIC8gOF07Cit9Owor
REVGSU5FX0dVRVNUX0hBTkRMRV9TVFJVQ1QobWNfaW5mbyk7CisKKyNkZWZpbmUgX19NQ19NU1Jf
QVJSQVlTSVpFIDgKKyNkZWZpbmUgX19NQ19NU1JfTUNHQ0FQIDAKKyNkZWZpbmUgX19NQ19OTVNS
UyAxCisjZGVmaW5lIE1DX05DQVBTIDcKK3N0cnVjdCBtY2luZm9fbG9naWNhbF9jcHUgeworCXVp
bnQzMl90IG1jX2NwdW5yOworCXVpbnQzMl90IG1jX2NoaXBpZDsKKwl1aW50MTZfdCBtY19jb3Jl
aWQ7CisJdWludDE2X3QgbWNfdGhyZWFkaWQ7CisJdWludDMyX3QgbWNfYXBpY2lkOworCXVpbnQz
Ml90IG1jX2NsdXN0ZXJpZDsKKwl1aW50MzJfdCBtY19uY29yZXM7CisJdWludDMyX3QgbWNfbmNv
cmVzX2FjdGl2ZTsKKwl1aW50MzJfdCBtY19udGhyZWFkczsKKwl1aW50MzJfdCBtY19jcHVpZF9s
ZXZlbDsKKwl1aW50MzJfdCBtY19mYW1pbHk7CisJdWludDMyX3QgbWNfdmVuZG9yOworCXVpbnQz
Ml90IG1jX21vZGVsOworCXVpbnQzMl90IG1jX3N0ZXA7CisJY2hhciBtY192ZW5kb3JpZFsxNl07
CisJY2hhciBtY19icmFuZGlkWzY0XTsKKwl1aW50MzJfdCBtY19jcHVfY2Fwc1tNQ19OQ0FQU107
CisJdWludDMyX3QgbWNfY2FjaGVfc2l6ZTsKKwl1aW50MzJfdCBtY19jYWNoZV9hbGlnbm1lbnQ7
CisJdWludDMyX3QgbWNfbm1zcnZhbHM7CisJc3RydWN0IG1jaW5mb19tc3IgbWNfbXNydmFsdWVz
W19fTUNfTVNSX0FSUkFZU0laRV07Cit9OworREVGSU5FX0dVRVNUX0hBTkRMRV9TVFJVQ1QobWNp
bmZvX2xvZ2ljYWxfY3B1KTsKKworLyoKKyAqIFByb3RvdHlwZToKKyAqICAgIHVpbnQzMl90IHg4
Nl9tY2luZm9fbmVudHJpZXMoc3RydWN0IG1jX2luZm8gKm1pKTsKKyAqLworI2RlZmluZSB4ODZf
bWNpbmZvX25lbnRyaWVzKF9taSkgICAgXAorCSgoX21pKS0+bWlfbmVudHJpZXMpCisvKgorICog
UHJvdG90eXBlOgorICogICAgc3RydWN0IG1jaW5mb19jb21tb24gKng4Nl9tY2luZm9fZmlyc3Qo
c3RydWN0IG1jX2luZm8gKm1pKTsKKyAqLworI2RlZmluZSB4ODZfbWNpbmZvX2ZpcnN0KF9taSkg
ICAgICAgXAorCSgoc3RydWN0IG1jaW5mb19jb21tb24gKikoX21pKS0+bWlfZGF0YSkKKy8qCisg
KiBQcm90b3R5cGU6CisgKiAgICBzdHJ1Y3QgbWNpbmZvX2NvbW1vbiAqeDg2X21jaW5mb19uZXh0
KHN0cnVjdCBtY2luZm9fY29tbW9uICptaWMpOworICovCisjZGVmaW5lIHg4Nl9tY2luZm9fbmV4
dChfbWljKSAgICAgICBcCisJKChzdHJ1Y3QgbWNpbmZvX2NvbW1vbiAqKSgodWludDhfdCAqKShf
bWljKSArIChfbWljKS0+c2l6ZSkpCisKKy8qCisgKiBQcm90b3R5cGU6CisgKiAgICB2b2lkIHg4
Nl9tY2luZm9fbG9va3VwKHZvaWQgKnJldCwgc3RydWN0IG1jX2luZm8gKm1pLCB1aW50MTZfdCB0
eXBlKTsKKyAqLworc3RhdGljIGlubGluZSB2b2lkIHg4Nl9tY2luZm9fbG9va3VwKHN0cnVjdCBt
Y2luZm9fY29tbW9uICoqcmV0LAorCQkJCSAgICAgc3RydWN0IG1jX2luZm8gKm1pLCB1aW50MTZf
dCB0eXBlKQoreworCXVpbnQzMl90IGk7CisJc3RydWN0IG1jaW5mb19jb21tb24gKm1pYzsKKwli
b29sIGZvdW5kID0gMDsKKworCWlmICghcmV0IHx8ICFtaSkKKwkJcmV0dXJuOworCisJbWljID0g
eDg2X21jaW5mb19maXJzdChtaSk7CisJZm9yIChpID0gMDsgaSA8IHg4Nl9tY2luZm9fbmVudHJp
ZXMobWkpOyBpKyspIHsKKwkJaWYgKG1pYy0+dHlwZSA9PSB0eXBlKSB7CisJCQlmb3VuZCA9IDE7
CisJCQlicmVhazsKKwkJfQorCQltaWMgPSB4ODZfbWNpbmZvX25leHQobWljKTsKKwl9CisKKwkq
cmV0ID0gZm91bmQgPyBtaWMgOiBOVUxMOworfQorCisvKgorICogRmV0Y2ggbWFjaGluZSBjaGVj
ayBkYXRhIGZyb20gaHlwZXJ2aXNvci4KKyAqLworI2RlZmluZSBYRU5fTUNfZmV0Y2gJCTEKK3N0
cnVjdCB4ZW5fbWNfZmV0Y2ggeworCS8qCisJICogSU46IFhFTl9NQ19OT05VUkdFTlQsIFhFTl9N
Q19VUkdFTlQsCisJICogWEVOX01DX0FDSyBpZiBhY2sna2luZyBhbiBlYXJsaWVyIGZldGNoCisJ
ICogT1VUOiBYRU5fTUNfT0ssIFhFTl9NQ19GRVRDSEFJTEVELCBYRU5fTUNfTk9EQVRBCisJICov
CisJdWludDMyX3QgZmxhZ3M7CisJdWludDMyX3QgX3BhZDA7CisJLyogT1VUOiBpZCBmb3IgYWNr
LCBJTjogaWQgd2UgYXJlIGFjaydpbmcgKi8KKwl1aW50NjRfdCBmZXRjaF9pZDsKKworCS8qIE9V
VCB2YXJpYWJsZXMuICovCisJR1VFU1RfSEFORExFKG1jX2luZm8pIGRhdGE7Cit9OworREVGSU5F
X0dVRVNUX0hBTkRMRV9TVFJVQ1QoeGVuX21jX2ZldGNoKTsKKworCisvKgorICogVGhpcyB0ZWxs
cyB0aGUgaHlwZXJ2aXNvciB0byBub3RpZnkgYSBEb21VIGFib3V0IHRoZSBtYWNoaW5lIGNoZWNr
IGVycm9yCisgKi8KKyNkZWZpbmUgWEVOX01DX25vdGlmeWRvbWFpbgkyCitzdHJ1Y3QgeGVuX21j
X25vdGlmeWRvbWFpbiB7CisJLyogSU4gdmFyaWFibGVzICovCisJdWludDE2X3QgbWNfZG9taWQ7
IC8qIFRoZSB1bnByaXZpbGVnZWQgZG9tYWluIHRvIG5vdGlmeSAqLworCXVpbnQxNl90IG1jX3Zj
cHVpZDsgLyogVGhlIHZjcHUgaW4gbWNfZG9taWQgdG8gbm90aWZ5ICovCisKKwkvKiBJTi9PVVQg
dmFyaWFibGVzICovCisJdWludDMyX3QgZmxhZ3M7Cit9OworREVGSU5FX0dVRVNUX0hBTkRMRV9T
VFJVQ1QoeGVuX21jX25vdGlmeWRvbWFpbik7CisKKyNkZWZpbmUgWEVOX01DX3BoeXNjcHVpbmZv
CTMKK3N0cnVjdCB4ZW5fbWNfcGh5c2NwdWluZm8geworCS8qIElOL09VVCAqLworCXVpbnQzMl90
IG5jcHVzOworCXVpbnQzMl90IF9wYWQwOworCS8qIE9VVCAqLworCUdVRVNUX0hBTkRMRShtY2lu
Zm9fbG9naWNhbF9jcHUpIGluZm87Cit9OworCisjZGVmaW5lIFhFTl9NQ19tc3JpbmplY3QJNAor
I2RlZmluZSBNQ19NU1JJTkpfTUFYTVNSUwk4CitzdHJ1Y3QgeGVuX21jX21zcmluamVjdCB7CisJ
LyogSU4gKi8KKwl1aW50MzJfdCBtY2lual9jcHVucjsgLyogdGFyZ2V0IHByb2Nlc3NvciBpZCAq
LworCXVpbnQzMl90IG1jaW5qX2ZsYWdzOyAvKiBzZWUgTUNfTVNSSU5KX0ZfKiBiZWxvdyAqLwor
CXVpbnQzMl90IG1jaW5qX2NvdW50OyAvKiAwIC4uIGNvdW50LTEgaW4gYXJyYXkgYXJlIHZhbGlk
ICovCisJdWludDMyX3QgX3BhZDA7CisJc3RydWN0IG1jaW5mb19tc3IgbWNpbmpfbXNyW01DX01T
UklOSl9NQVhNU1JTXTsKK307CisKKy8qIEZsYWdzIGZvciBtY2lual9mbGFncyBhYm92ZTsgYml0
cyAxNi0zMSBhcmUgcmVzZXJ2ZWQgKi8KKyNkZWZpbmUgTUNfTVNSSU5KX0ZfSU5URVJQT1NFCTB4
MQorCisjZGVmaW5lIFhFTl9NQ19tY2VpbmplY3QJNQorc3RydWN0IHhlbl9tY19tY2VpbmplY3Qg
eworCXVuc2lnbmVkIGludCBtY2VpbmpfY3B1bnI7IC8qIHRhcmdldCBwcm9jZXNzb3IgaWQgKi8K
K307CisKK3N0cnVjdCB4ZW5fbWMgeworCXVpbnQzMl90IGNtZDsKKwl1aW50MzJfdCBpbnRlcmZh
Y2VfdmVyc2lvbjsgLyogWEVOX01DQV9JTlRFUkZBQ0VfVkVSU0lPTiAqLworCXVuaW9uIHsKKwkJ
c3RydWN0IHhlbl9tY19mZXRjaCAgICAgICAgbWNfZmV0Y2g7CisJCXN0cnVjdCB4ZW5fbWNfbm90
aWZ5ZG9tYWluIG1jX25vdGlmeWRvbWFpbjsKKwkJc3RydWN0IHhlbl9tY19waHlzY3B1aW5mbyAg
bWNfcGh5c2NwdWluZm87CisJCXN0cnVjdCB4ZW5fbWNfbXNyaW5qZWN0ICAgIG1jX21zcmluamVj
dDsKKwkJc3RydWN0IHhlbl9tY19tY2VpbmplY3QgICAgbWNfbWNlaW5qZWN0OworCX0gdTsKK307
CitERUZJTkVfR1VFU1RfSEFORExFX1NUUlVDVCh4ZW5fbWMpOworCisvKiBGaWVsZHMgYXJlIHpl
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

--_002_DE8DF0795D48FD4CA783C40EC82923351FFB48SHSMSX101ccrcorpi_--
