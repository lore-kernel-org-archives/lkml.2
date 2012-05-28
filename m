Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2E1OsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 10:48:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:34985 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab2E1OsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 10:48:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="148599916"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@amd64.org>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>
Subject: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (RFC)
Thread-Topic: [PATCH 1/3] xen/mce: Add mcelog support for Xen platform (RFC)
Thread-Index: AQHNOqBYr6jLO/PX8Ee8ZH/5SHvSCZba1ybwgARWupCAAB0loA==
Date: Mon, 28 May 2012 14:48:06 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351F44F3@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923351D6892@SHSMSX101.ccr.corp.intel.com>
 <20120522092354.GB18578@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351EC9B0@SHSMSX101.ccr.corp.intel.com>
 <20120524103023.GA27063@aftab.osrc.amd.com>
 <DE8DF0795D48FD4CA783C40EC82923351ED712@SHSMSX101.ccr.corp.intel.com>
 <20120524184947.GA28338@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0C4E@SHSMSX101.ccr.corp.intel.com>
 <20120525180102.GA27280@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351F0D53@SHSMSX101.ccr.corp.intel.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923351F44F3SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923351F44F3SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Borislav and Konrad,
>=20
> An approach which basically same as you suggested but w/ slightly
> update, is 1). at xen/mcelog.c, do
> misc_register(&xen_mce_chrdev_device) at xen_late_init_mcelog, define
> it as device_initcall(xen_late_init_mcelog) --> now linux dd ready,
> so xen mcelog divice would register successfully; 2). at native
> mce.c, change 1 line from device_initcall(mcheck_init_device) to
> device_initcall_sync(mcheck_init_device) --> so
> misc_register(&mce_chrdev_device) would be blocked by xen mcelog
> device;     =20
>=20
> I have draft test it and works fine.
> Thought?
>=20

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RFC patch attached:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


>From d06e667632507d7ed8e18f952b0eb7cec3cfc55c Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Tue, 29 May 2012 06:13:19 +0800
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
index d086a09..8a6913b 100644
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
@@ -2282,7 +2280,7 @@ static __init int mcheck_init_device(void)
=20
 	return err;
 }
-device_initcall(mcheck_init_device);
+device_initcall_sync(mcheck_init_device);
=20
 /*
  * Old style boot options parsing. Only for compatibility.
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 4f51beb..b2638b1 100644
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

--_002_DE8DF0795D48FD4CA783C40EC82923351F44F3SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-xen-mce-Add-mcelog-support-for-Xen-platform.patch"
Content-Description: 0001-xen-mce-Add-mcelog-support-for-Xen-platform.patch
Content-Disposition: attachment;
	filename="0001-xen-mce-Add-mcelog-support-for-Xen-platform.patch";
	size=27089; creation-date="Mon, 28 May 2012 14:41:59 GMT";
	modification-date="Mon, 28 May 2012 22:35:16 GMT"
Content-Transfer-Encoding: base64

RnJvbSBkMDZlNjY3NjMyNTA3ZDdlZDhlMThmOTUyYjBlYjdjZWMzY2ZjNTVjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogVHVlLCAyOSBNYXkgMjAxMiAwNjoxMzoxOSArMDgwMApTdWJqZWN0OiBbUEFUQ0ggMS8z
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
U2lnbmVkLW9mZi1ieTogS2UsIExpcGluZyA8bGlwaW5nLmtlQGludGVsLmNvbT4KU2lnbmVkLW9m
Zi1ieTogSmlhbmcsIFl1bmhvbmcgPHl1bmhvbmcuamlhbmdAaW50ZWwuY29tPgpTaWduZWQtb2Zm
LWJ5OiBKZXJlbXkgRml0emhhcmRpbmdlIDxqZXJlbXkuZml0emhhcmRpbmdlQGNpdHJpeC5jb20+
ClNpZ25lZC1vZmYtYnk6IExpdSwgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgotLS0K
IGFyY2gveDg2L2luY2x1ZGUvYXNtL3hlbi9oeXBlcmNhbGwuaCB8ICAgIDggKwogYXJjaC94ODYv
a2VybmVsL2NwdS9tY2hlY2svbWNlLmMgICAgIHwgICAgNCArLQogYXJjaC94ODYveGVuL2VubGln
aHRlbi5jICAgICAgICAgICAgIHwgICAgNSArLQogZHJpdmVycy94ZW4vS2NvbmZpZyAgICAgICAg
ICAgICAgICAgIHwgICAgOCArCiBkcml2ZXJzL3hlbi9NYWtlZmlsZSAgICAgICAgICAgICAgICAg
fCAgICAxICsKIGRyaXZlcnMveGVuL21jZWxvZy5jICAgICAgICAgICAgICAgICB8ICAzOTIgKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogaW5jbHVkZS9saW51eC9taXNjZGV2aWNl
LmggICAgICAgICAgIHwgICAgMSArCiBpbmNsdWRlL3hlbi9pbnRlcmZhY2UveGVuLW1jYS5oICAg
ICAgfCAgMzg1ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogOCBmaWxlcyBjaGFu
Z2VkLCA3OTggaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKIGNyZWF0ZSBtb2RlIDEwMDY0
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
IGIvYXJjaC94ODYva2VybmVsL2NwdS9tY2hlY2svbWNlLmMKaW5kZXggZDA4NmEwOS4uOGE2OTEz
YiAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9tY2hlY2svbWNlLmMKKysrIGIvYXJj
aC94ODYva2VybmVsL2NwdS9tY2hlY2svbWNlLmMKQEAgLTU3LDggKzU3LDYgQEAgc3RhdGljIERF
RklORV9NVVRFWChtY2VfY2hyZGV2X3JlYWRfbXV0ZXgpOwogCiBpbnQgbWNlX2Rpc2FibGVkIF9f
cmVhZF9tb3N0bHk7CiAKLSNkZWZpbmUgTUlTQ19NQ0VMT0dfTUlOT1IJMjI3Ci0KICNkZWZpbmUg
U1BJTlVOSVQgMTAwCS8qIDEwMG5zICovCiAKIGF0b21pY190IG1jZV9lbnRyeTsKQEAgLTIyODIs
NyArMjI4MCw3IEBAIHN0YXRpYyBfX2luaXQgaW50IG1jaGVja19pbml0X2RldmljZSh2b2lkKQog
CiAJcmV0dXJuIGVycjsKIH0KLWRldmljZV9pbml0Y2FsbChtY2hlY2tfaW5pdF9kZXZpY2UpOwor
ZGV2aWNlX2luaXRjYWxsX3N5bmMobWNoZWNrX2luaXRfZGV2aWNlKTsKIAogLyoKICAqIE9sZCBz
dHlsZSBib290IG9wdGlvbnMgcGFyc2luZy4gT25seSBmb3IgY29tcGF0aWJpbGl0eS4KZGlmZiAt
LWdpdCBhL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYyBiL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4u
YwppbmRleCA0ZjUxYmViLi5iMjYzOGIxIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni94ZW4vZW5saWdo
dGVuLmMKKysrIGIvYXJjaC94ODYveGVuL2VubGlnaHRlbi5jCkBAIC0zOCw2ICszOCw3IEBACiAj
aW5jbHVkZSA8eGVuL2ludGVyZmFjZS9waHlzZGV2Lmg+CiAjaW5jbHVkZSA8eGVuL2ludGVyZmFj
ZS92Y3B1Lmg+CiAjaW5jbHVkZSA8eGVuL2ludGVyZmFjZS9tZW1vcnkuaD4KKyNpbmNsdWRlIDx4
ZW4vaW50ZXJmYWNlL3hlbi1tY2EuaD4KICNpbmNsdWRlIDx4ZW4vZmVhdHVyZXMuaD4KICNpbmNs
dWRlIDx4ZW4vcGFnZS5oPgogI2luY2x1ZGUgPHhlbi9odm0uaD4KQEAgLTMyOSw5ICszMzAsNyBA
QCBzdGF0aWMgdm9pZCBfX2luaXQgeGVuX2luaXRfY3B1aWRfbWFzayh2b2lkKQogCXVuc2lnbmVk
IGludCB4c2F2ZV9tYXNrOwogCiAJY3B1aWRfbGVhZjFfZWR4X21hc2sgPQotCQl+KCgxIDw8IFg4
Nl9GRUFUVVJFX01DRSkgIHwgIC8qIGRpc2FibGUgTUNFICovCi0JCSAgKDEgPDwgWDg2X0ZFQVRV
UkVfTUNBKSAgfCAgLyogZGlzYWJsZSBNQ0EgKi8KLQkJICAoMSA8PCBYODZfRkVBVFVSRV9NVFJS
KSB8ICAvKiBkaXNhYmxlIE1UUlIgKi8KKwkJfigoMSA8PCBYODZfRkVBVFVSRV9NVFJSKSB8ICAv
KiBkaXNhYmxlIE1UUlIgKi8KIAkJICAoMSA8PCBYODZfRkVBVFVSRV9BQ0MpKTsgICAvKiB0aGVy
bWFsIG1vbml0b3JpbmcgKi8KIAogCWlmICgheGVuX2luaXRpYWxfZG9tYWluKCkpCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3hlbi9LY29uZmlnIGIvZHJpdmVycy94ZW4vS2NvbmZpZwppbmRleCA5NDI0
MzEzLi4wZjU0MjQxIDEwMDY0NAotLS0gYS9kcml2ZXJzL3hlbi9LY29uZmlnCisrKyBiL2RyaXZl
cnMveGVuL0tjb25maWcKQEAgLTE5NCw0ICsxOTQsMTIgQEAgY29uZmlnIFhFTl9BQ1BJX1BST0NF
U1NPUgogICAgICAgICAgIG1vZHVsZSB3aWxsIGJlIGNhbGxlZCB4ZW5fYWNwaV9wcm9jZXNzb3Ig
IElmIHlvdSBkbyBub3Qga25vdyB3aGF0IHRvIGNob29zZSwKICAgICAgICAgICBzZWxlY3QgTSBo
ZXJlLiBJZiB0aGUgQ1BVRlJFUSBkcml2ZXJzIGFyZSBidWlsdCBpbiwgc2VsZWN0IFkgaGVyZS4K
IAorY29uZmlnIFhFTl9NQ0VfTE9HCisJYm9vbCAiWGVuIHBsYXRmb3JtIG1jZWxvZyIKKwlkZXBl
bmRzIG9uIFhFTl9ET00wICYmIFg4Nl82NCAmJiBYODZfTUNFCisJZGVmYXVsdCBuCisJaGVscAor
CSAgQWxsb3cga2VybmVsIGZldGNoaW5nIE1DRSBlcnJvciBmcm9tIFhlbiBwbGF0Zm9ybSBhbmQK
KwkgIGNvbnZlcnRpbmcgaXQgaW50byBMaW51eCBtY2Vsb2cgZm9ybWF0IGZvciBtY2Vsb2cgdG9v
bHMKKwogZW5kbWVudQpkaWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4vTWFrZWZpbGUgYi9kcml2ZXJz
L3hlbi9NYWtlZmlsZQppbmRleCA5YWRjNWJlLi4xZDNlNzYzIDEwMDY0NAotLS0gYS9kcml2ZXJz
L3hlbi9NYWtlZmlsZQorKysgYi9kcml2ZXJzL3hlbi9NYWtlZmlsZQpAQCAtMTQsNiArMTQsNyBA
QCBvYmotJChDT05GSUdfWEVOX0dOVERFVikJCSs9IHhlbi1nbnRkZXYubwogb2JqLSQoQ09ORklH
X1hFTl9HUkFOVF9ERVZfQUxMT0MpCSs9IHhlbi1nbnRhbGxvYy5vCiBvYmotJChDT05GSUdfWEVO
RlMpCQkJKz0geGVuZnMvCiBvYmotJChDT05GSUdfWEVOX1NZU19IWVBFUlZJU09SKQkrPSBzeXMt
aHlwZXJ2aXNvci5vCitvYmotJChDT05GSUdfWEVOX01DRV9MT0cpCQkrPSBtY2Vsb2cubwogb2Jq
LSQoQ09ORklHX1hFTl9QVkhWTSkJCQkrPSBwbGF0Zm9ybS1wY2kubwogb2JqLSQoQ09ORklHX1hF
Tl9UTUVNKQkJCSs9IHRtZW0ubwogb2JqLSQoQ09ORklHX1NXSU9UTEJfWEVOKQkJKz0gc3dpb3Rs
Yi14ZW4ubwpkaWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4vbWNlbG9nLmMgYi9kcml2ZXJzL3hlbi9t
Y2Vsb2cuYwpuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwLi43MmU4N2QyCi0tLSAv
ZGV2L251bGwKKysrIGIvZHJpdmVycy94ZW4vbWNlbG9nLmMKQEAgLTAsMCArMSwzOTIgQEAKKy8q
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioKKyAqIG1jZWxvZy5jCisgKiBEcml2ZXIgZm9yIHJlY2Vpdmlu
ZyBhbmQgdHJhbnNmZXJyaW5nIG1hY2hpbmUgY2hlY2sgZXJyb3IgaW5mb21hdGlvbgorICoKKyAq
IENvcHlyaWdodCAoYykgMjAxMiBJbnRlbCBDb3Jwb3JhdGlvbgorICogQXV0aG9yOiBMaXUsIEpp
bnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4KKyAqIEF1dGhvcjogSmlhbmcsIFl1bmhvbmcg
PHl1bmhvbmcuamlhbmdAaW50ZWwuY29tPgorICogQXV0aG9yOiBLZSwgTGlwaW5nIDxsaXBpbmcu
a2VAaW50ZWwuY29tPgorICoKKyAqIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3Ug
Y2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IKKyAqIG1vZGlmeSBpdCB1bmRlciB0aGUgdGVybXMg
b2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIHZlcnNpb24gMgorICogYXMgcHVibGlz
aGVkIGJ5IHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IG9yLCB3aGVuIGRpc3RyaWJ1dGVk
CisgKiBzZXBhcmF0ZWx5IGZyb20gdGhlIExpbnV4IGtlcm5lbCBvciBpbmNvcnBvcmF0ZWQgaW50
byBvdGhlcgorICogc29mdHdhcmUgcGFja2FnZXMsIHN1YmplY3QgdG8gdGhlIGZvbGxvd2luZyBs
aWNlbnNlOgorICoKKyAqIFBlcm1pc3Npb24gaXMgaGVyZWJ5IGdyYW50ZWQsIGZyZWUgb2YgY2hh
cmdlLCB0byBhbnkgcGVyc29uIG9idGFpbmluZyBhIGNvcHkKKyAqIG9mIHRoaXMgc291cmNlIGZp
bGUgKHRoZSAiU29mdHdhcmUiKSwgdG8gZGVhbCBpbiB0aGUgU29mdHdhcmUgd2l0aG91dAorICog
cmVzdHJpY3Rpb24sIGluY2x1ZGluZyB3aXRob3V0IGxpbWl0YXRpb24gdGhlIHJpZ2h0cyB0byB1
c2UsIGNvcHksIG1vZGlmeSwKKyAqIG1lcmdlLCBwdWJsaXNoLCBkaXN0cmlidXRlLCBzdWJsaWNl
bnNlLCBhbmQvb3Igc2VsbCBjb3BpZXMgb2YgdGhlIFNvZnR3YXJlLAorICogYW5kIHRvIHBlcm1p
dCBwZXJzb25zIHRvIHdob20gdGhlIFNvZnR3YXJlIGlzIGZ1cm5pc2hlZCB0byBkbyBzbywgc3Vi
amVjdCB0bworICogdGhlIGZvbGxvd2luZyBjb25kaXRpb25zOgorICoKKyAqIFRoZSBhYm92ZSBj
b3B5cmlnaHQgbm90aWNlIGFuZCB0aGlzIHBlcm1pc3Npb24gbm90aWNlIHNoYWxsIGJlIGluY2x1
ZGVkIGluCisgKiBhbGwgY29waWVzIG9yIHN1YnN0YW50aWFsIHBvcnRpb25zIG9mIHRoZSBTb2Z0
d2FyZS4KKyAqCisgKiBUSEUgU09GVFdBUkUgSVMgUFJPVklERUQgIkFTIElTIiwgV0lUSE9VVCBX
QVJSQU5UWSBPRiBBTlkgS0lORCwgRVhQUkVTUyBPUgorICogSU1QTElFRCwgSU5DTFVESU5HIEJV
VCBOT1QgTElNSVRFRCBUTyBUSEUgV0FSUkFOVElFUyBPRiBNRVJDSEFOVEFCSUxJVFksCisgKiBG
SVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRSBBTkQgTk9OSU5GUklOR0VNRU5ULiBJTiBO
TyBFVkVOVCBTSEFMTCBUSEUKKyAqIEFVVEhPUlMgT1IgQ09QWVJJR0hUIEhPTERFUlMgQkUgTElB
QkxFIEZPUiBBTlkgQ0xBSU0sIERBTUFHRVMgT1IgT1RIRVIKKyAqIExJQUJJTElUWSwgV0hFVEhF
UiBJTiBBTiBBQ1RJT04gT0YgQ09OVFJBQ1QsIFRPUlQgT1IgT1RIRVJXSVNFLCBBUklTSU5HCisg
KiBGUk9NLCBPVVQgT0YgT1IgSU4gQ09OTkVDVElPTiBXSVRIIFRIRSBTT0ZUV0FSRSBPUiBUSEUg
VVNFIE9SIE9USEVSIERFQUxJTkdTCisgKiBJTiBUSEUgU09GVFdBUkUuCisgKi8KKworI2luY2x1
ZGUgPGxpbnV4L2luaXQuaD4KKyNpbmNsdWRlIDxsaW51eC90eXBlcy5oPgorI2luY2x1ZGUgPGxp
bnV4L2tlcm5lbC5oPgorI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4KKyNpbmNsdWRlIDxsaW51eC9m
cy5oPgorI2luY2x1ZGUgPGxpbnV4L2RldmljZS5oPgorI2luY2x1ZGUgPGxpbnV4L21pc2NkZXZp
Y2UuaD4KKyNpbmNsdWRlIDxsaW51eC91YWNjZXNzLmg+CisjaW5jbHVkZSA8bGludXgvY2FwYWJp
bGl0eS5oPgorCisjaW5jbHVkZSA8eGVuL2ludGVyZmFjZS94ZW4uaD4KKyNpbmNsdWRlIDx4ZW4v
ZXZlbnRzLmg+CisjaW5jbHVkZSA8eGVuL2ludGVyZmFjZS92Y3B1Lmg+CisjaW5jbHVkZSA8eGVu
L3hlbi5oPgorI2luY2x1ZGUgPGFzbS94ZW4vaHlwZXJjYWxsLmg+CisjaW5jbHVkZSA8YXNtL3hl
bi9oeXBlcnZpc29yLmg+CisKKyNkZWZpbmUgWEVOX01DRUxPRyAieGVuX21jZWxvZzogIgorCitz
dGF0aWMgc3RydWN0IG1jX2luZm8gZ19taTsKK3N0YXRpYyBzdHJ1Y3QgbWNpbmZvX2xvZ2ljYWxf
Y3B1ICpnX3BoeXNpbmZvOworc3RhdGljIHVpbnQzMl90IG5jcHVzOworCitzdGF0aWMgREVGSU5F
X1NQSU5MT0NLKG1jZWxvZ19sb2NrKTsKKworc3RhdGljIHN0cnVjdCB4ZW5fbWNlX2xvZyB4ZW5f
bWNlbG9nID0geworCS5zaWduYXR1cmUJPSBYRU5fTUNFX0xPR19TSUdOQVRVUkUsCisJLmxlbgkJ
PSBYRU5fTUNFX0xPR19MRU4sCisJLnJlY29yZGxlbgk9IHNpemVvZihzdHJ1Y3QgeGVuX21jZSks
Cit9OworCitzdGF0aWMgREVGSU5FX1NQSU5MT0NLKHhlbl9tY2VfY2hyZGV2X3N0YXRlX2xvY2sp
Oworc3RhdGljIGludCB4ZW5fbWNlX2NocmRldl9vcGVuX2NvdW50OwkvKiAjdGltZXMgb3BlbmVk
ICovCitzdGF0aWMgaW50IHhlbl9tY2VfY2hyZGV2X29wZW5fZXhjbHU7CS8qIGFscmVhZHkgb3Bl
biBleGNsdXNpdmU/ICovCisKK3N0YXRpYyBpbnQgeGVuX21jZV9jaHJkZXZfb3BlbihzdHJ1Y3Qg
aW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKK3sKKwlzcGluX2xvY2soJnhlbl9tY2Vf
Y2hyZGV2X3N0YXRlX2xvY2spOworCisJaWYgKHhlbl9tY2VfY2hyZGV2X29wZW5fZXhjbHUgfHwK
KwkgICAgKHhlbl9tY2VfY2hyZGV2X29wZW5fY291bnQgJiYgKGZpbGUtPmZfZmxhZ3MgJiBPX0VY
Q0wpKSkgeworCQlzcGluX3VubG9jaygmeGVuX21jZV9jaHJkZXZfc3RhdGVfbG9jayk7CisKKwkJ
cmV0dXJuIC1FQlVTWTsKKwl9CisKKwlpZiAoZmlsZS0+Zl9mbGFncyAmIE9fRVhDTCkKKwkJeGVu
X21jZV9jaHJkZXZfb3Blbl9leGNsdSA9IDE7CisJeGVuX21jZV9jaHJkZXZfb3Blbl9jb3VudCsr
OworCisJc3Bpbl91bmxvY2soJnhlbl9tY2VfY2hyZGV2X3N0YXRlX2xvY2spOworCisJcmV0dXJu
IG5vbnNlZWthYmxlX29wZW4oaW5vZGUsIGZpbGUpOworfQorCitzdGF0aWMgaW50IHhlbl9tY2Vf
Y2hyZGV2X3JlbGVhc2Uoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpCit7
CisJc3Bpbl9sb2NrKCZ4ZW5fbWNlX2NocmRldl9zdGF0ZV9sb2NrKTsKKworCXhlbl9tY2VfY2hy
ZGV2X29wZW5fY291bnQtLTsKKwl4ZW5fbWNlX2NocmRldl9vcGVuX2V4Y2x1ID0gMDsKKworCXNw
aW5fdW5sb2NrKCZ4ZW5fbWNlX2NocmRldl9zdGF0ZV9sb2NrKTsKKworCXJldHVybiAwOworfQor
CitzdGF0aWMgc3NpemVfdCB4ZW5fbWNlX2NocmRldl9yZWFkKHN0cnVjdCBmaWxlICpmaWxwLCBj
aGFyIF9fdXNlciAqdWJ1ZiwKKwkJCQlzaXplX3QgdXNpemUsIGxvZmZfdCAqb2ZmKQoreworCWNo
YXIgX191c2VyICpidWYgPSB1YnVmOworCXVuc2lnbmVkIG51bTsKKwlpbnQgaSwgZXJyOworCisJ
c3Bpbl9sb2NrKCZtY2Vsb2dfbG9jayk7CisKKwludW0gPSB4ZW5fbWNlbG9nLm5leHQ7CisKKwkv
KiBPbmx5IHN1cHBvcnRzIGZ1bGwgcmVhZHMgcmlnaHQgbm93ICovCisJZXJyID0gLUVJTlZBTDsK
KwlpZiAoKm9mZiAhPSAwIHx8IHVzaXplIDwgWEVOX01DRV9MT0dfTEVOKnNpemVvZihzdHJ1Y3Qg
eGVuX21jZSkpCisJCWdvdG8gb3V0OworCisJZXJyID0gMDsKKwlmb3IgKGkgPSAwOyBpIDwgbnVt
OyBpKyspIHsKKwkJc3RydWN0IHhlbl9tY2UgKm0gPSAmeGVuX21jZWxvZy5lbnRyeVtpXTsKKwor
CQllcnIgfD0gY29weV90b191c2VyKGJ1ZiwgbSwgc2l6ZW9mKCptKSk7CisJCWJ1ZiArPSBzaXpl
b2YoKm0pOworCX0KKworCW1lbXNldCh4ZW5fbWNlbG9nLmVudHJ5LCAwLCBudW0gKiBzaXplb2Yo
c3RydWN0IHhlbl9tY2UpKTsKKwl4ZW5fbWNlbG9nLm5leHQgPSAwOworCisJaWYgKGVycikKKwkJ
ZXJyID0gLUVGQVVMVDsKKworb3V0OgorCXNwaW5fdW5sb2NrKCZtY2Vsb2dfbG9jayk7CisKKwly
ZXR1cm4gZXJyID8gZXJyIDogYnVmIC0gdWJ1ZjsKK30KKworc3RhdGljIGxvbmcgeGVuX21jZV9j
aHJkZXZfaW9jdGwoc3RydWN0IGZpbGUgKmYsIHVuc2lnbmVkIGludCBjbWQsCisJCQkJdW5zaWdu
ZWQgbG9uZyBhcmcpCit7CisJaW50IF9fdXNlciAqcCA9IChpbnQgX191c2VyICopYXJnOworCisJ
aWYgKCFjYXBhYmxlKENBUF9TWVNfQURNSU4pKQorCQlyZXR1cm4gLUVQRVJNOworCisJc3dpdGNo
IChjbWQpIHsKKwljYXNlIE1DRV9HRVRfUkVDT1JEX0xFTjoKKwkJcmV0dXJuIHB1dF91c2VyKHNp
emVvZihzdHJ1Y3QgeGVuX21jZSksIHApOworCWNhc2UgTUNFX0dFVF9MT0dfTEVOOgorCQlyZXR1
cm4gcHV0X3VzZXIoWEVOX01DRV9MT0dfTEVOLCBwKTsKKwljYXNlIE1DRV9HRVRDTEVBUl9GTEFH
UzogeworCQl1bnNpZ25lZCBmbGFnczsKKworCQlkbyB7CisJCQlmbGFncyA9IHhlbl9tY2Vsb2cu
ZmxhZ3M7CisJCX0gd2hpbGUgKGNtcHhjaGcoJnhlbl9tY2Vsb2cuZmxhZ3MsIGZsYWdzLCAwKSAh
PSBmbGFncyk7CisKKwkJcmV0dXJuIHB1dF91c2VyKGZsYWdzLCBwKTsKKwl9CisJZGVmYXVsdDoK
KwkJcmV0dXJuIC1FTk9UVFk7CisJfQorfQorCitzdGF0aWMgY29uc3Qgc3RydWN0IGZpbGVfb3Bl
cmF0aW9ucyB4ZW5fbWNlX2NocmRldl9vcHMgPSB7CisJLm9wZW4JCQk9IHhlbl9tY2VfY2hyZGV2
X29wZW4sCisJLnJlbGVhc2UJCT0geGVuX21jZV9jaHJkZXZfcmVsZWFzZSwKKwkucmVhZAkJCT0g
eGVuX21jZV9jaHJkZXZfcmVhZCwKKwkudW5sb2NrZWRfaW9jdGwJCT0geGVuX21jZV9jaHJkZXZf
aW9jdGwsCisJLmxsc2VlawkJCT0gbm9fbGxzZWVrLAorfTsKKworc3RhdGljIHN0cnVjdCBtaXNj
ZGV2aWNlIHhlbl9tY2VfY2hyZGV2X2RldmljZSA9IHsKKwlNSVNDX01DRUxPR19NSU5PUiwKKwki
bWNlbG9nIiwKKwkmeGVuX21jZV9jaHJkZXZfb3BzLAorfTsKKworLyoKKyAqIENhbGxlciBzaG91
bGQgaG9sZCB0aGUgbWNlbG9nX2xvY2sKKyAqLworc3RhdGljIHZvaWQgeGVuX21jZV9sb2coc3Ry
dWN0IHhlbl9tY2UgKm1jZSkKK3sKKwl1bnNpZ25lZCBlbnRyeTsKKworCWVudHJ5ID0geGVuX21j
ZWxvZy5uZXh0OworCisJLyoKKwkgKiBXaGVuIHRoZSBidWZmZXIgZmlsbHMgdXAgZGlzY2FyZCBu
ZXcgZW50cmllcy4KKwkgKiBBc3N1bWUgdGhhdCB0aGUgZWFybGllciBlcnJvcnMgYXJlIHRoZSBt
b3JlCisJICogaW50ZXJlc3Rpbmcgb25lczoKKwkgKi8KKwlpZiAoZW50cnkgPj0gWEVOX01DRV9M
T0dfTEVOKSB7CisJCXNldF9iaXQoWEVOX01DRV9PVkVSRkxPVywKKwkJCSh1bnNpZ25lZCBsb25n
ICopJnhlbl9tY2Vsb2cuZmxhZ3MpOworCQlyZXR1cm47CisJfQorCisJbWVtY3B5KHhlbl9tY2Vs
b2cuZW50cnkgKyBlbnRyeSwgbWNlLCBzaXplb2Yoc3RydWN0IHhlbl9tY2UpKTsKKworCXhlbl9t
Y2Vsb2cubmV4dCsrOworfQorCitzdGF0aWMgaW50IGNvbnZlcnRfbG9nKHN0cnVjdCBtY19pbmZv
ICptaSkKK3sKKwlzdHJ1Y3QgbWNpbmZvX2NvbW1vbiAqbWljOworCXN0cnVjdCBtY2luZm9fZ2xv
YmFsICptY19nbG9iYWw7CisJc3RydWN0IG1jaW5mb19iYW5rICptY19iYW5rOworCXN0cnVjdCB4
ZW5fbWNlIG07CisJdWludDMyX3QgaTsKKworCW1pYyA9IE5VTEw7CisJeDg2X21jaW5mb19sb29r
dXAoJm1pYywgbWksIE1DX1RZUEVfR0xPQkFMKTsKKwlpZiAodW5saWtlbHkoIW1pYykpIHsKKwkJ
cHJfd2FybmluZyhYRU5fTUNFTE9HICJGYWlsZWQgdG8gZmluZCBnbG9iYWwgZXJyb3IgaW5mb1xu
Iik7CisJCXJldHVybiAtRU5PREVWOworCX0KKworCW1lbXNldCgmbSwgMCwgc2l6ZW9mKHN0cnVj
dCB4ZW5fbWNlKSk7CisKKwltY19nbG9iYWwgPSAoc3RydWN0IG1jaW5mb19nbG9iYWwgKiltaWM7
CisJbS5tY2dzdGF0dXMgPSBtY19nbG9iYWwtPm1jX2dzdGF0dXM7CisJbS5hcGljaWQgPSBtY19n
bG9iYWwtPm1jX2FwaWNpZDsKKworCWZvciAoaSA9IDA7IGkgPCBuY3B1czsgaSsrKQorCQlpZiAo
Z19waHlzaW5mb1tpXS5tY19hcGljaWQgPT0gbS5hcGljaWQpCisJCQlicmVhazsKKwlpZiAodW5s
aWtlbHkoaSA9PSBuY3B1cykpIHsKKwkJcHJfd2FybmluZyhYRU5fTUNFTE9HICJGYWlsZWQgdG8g
bWF0Y2ggY3B1IHdpdGggYXBpY2lkICVkXG4iLAorCQkJICAgbS5hcGljaWQpOworCQlyZXR1cm4g
LUVOT0RFVjsKKwl9CisKKwltLnNvY2tldGlkID0gZ19waHlzaW5mb1tpXS5tY19jaGlwaWQ7CisJ
bS5jcHUgPSBtLmV4dGNwdSA9IGdfcGh5c2luZm9baV0ubWNfY3B1bnI7CisJbS5jcHV2ZW5kb3Ig
PSAoX191OClnX3BoeXNpbmZvW2ldLm1jX3ZlbmRvcjsKKwltLm1jZ2NhcCA9IGdfcGh5c2luZm9b
aV0ubWNfbXNydmFsdWVzW19fTUNfTVNSX01DR0NBUF0udmFsdWU7CisKKwltaWMgPSBOVUxMOwor
CXg4Nl9tY2luZm9fbG9va3VwKCZtaWMsIG1pLCBNQ19UWVBFX0JBTkspOworCWlmICh1bmxpa2Vs
eSghbWljKSkgeworCQlwcl93YXJuaW5nKFhFTl9NQ0VMT0cgIkZhaWwgdG8gZmluZCBiYW5rIGVy
cm9yIGluZm9cbiIpOworCQlyZXR1cm4gLUVOT0RFVjsKKwl9CisKKwlkbyB7CisJCWlmICgoIW1p
YykgfHwgKG1pYy0+c2l6ZSA9PSAwKSB8fAorCQkgICAgKG1pYy0+dHlwZSAhPSBNQ19UWVBFX0dM
T0JBTCAgICYmCisJCSAgICAgbWljLT50eXBlICE9IE1DX1RZUEVfQkFOSyAgICAgJiYKKwkJICAg
ICBtaWMtPnR5cGUgIT0gTUNfVFlQRV9FWFRFTkRFRCAmJgorCQkgICAgIG1pYy0+dHlwZSAhPSBN
Q19UWVBFX1JFQ09WRVJZKSkKKwkJCWJyZWFrOworCisJCWlmIChtaWMtPnR5cGUgPT0gTUNfVFlQ
RV9CQU5LKSB7CisJCQltY19iYW5rID0gKHN0cnVjdCBtY2luZm9fYmFuayAqKW1pYzsKKwkJCW0u
bWlzYyA9IG1jX2JhbmstPm1jX21pc2M7CisJCQltLnN0YXR1cyA9IG1jX2JhbmstPm1jX3N0YXR1
czsKKwkJCW0uYWRkciA9IG1jX2JhbmstPm1jX2FkZHI7CisJCQltLnRzYyA9IG1jX2JhbmstPm1j
X3RzYzsKKwkJCW0uYmFuayA9IG1jX2JhbmstPm1jX2Jhbms7CisJCQltLmZpbmlzaGVkID0gMTsK
KwkJCS8qbG9nIHRoaXMgcmVjb3JkKi8KKwkJCXhlbl9tY2VfbG9nKCZtKTsKKwkJfQorCQltaWMg
PSB4ODZfbWNpbmZvX25leHQobWljKTsKKwl9IHdoaWxlICgxKTsKKworCXJldHVybiAwOworfQor
CitzdGF0aWMgaW50IG1jX3F1ZXVlX2hhbmRsZSh1aW50MzJfdCBmbGFncykKK3sKKwlzdHJ1Y3Qg
eGVuX21jIG1jX29wOworCWludCByZXQgPSAwOworCisJbWNfb3AuY21kID0gWEVOX01DX2ZldGNo
OworCW1jX29wLmludGVyZmFjZV92ZXJzaW9uID0gWEVOX01DQV9JTlRFUkZBQ0VfVkVSU0lPTjsK
KwlzZXRfeGVuX2d1ZXN0X2hhbmRsZShtY19vcC51Lm1jX2ZldGNoLmRhdGEsICZnX21pKTsKKwlk
byB7CisJCW1jX29wLnUubWNfZmV0Y2guZmxhZ3MgPSBmbGFnczsKKwkJcmV0ID0gSFlQRVJWSVNP
Ul9tY2EoJm1jX29wKTsKKwkJaWYgKHJldCkgeworCQkJcHJfZXJyKFhFTl9NQ0VMT0cgIkZhaWxl
ZCB0byBmZXRjaCAlcyBlcnJvciBsb2dcbiIsCisJCQkgICAgICAgKGZsYWdzID09IFhFTl9NQ19V
UkdFTlQpID8KKwkJCSAgICAgICAidXJnbmV0IiA6ICJub251cmdlbnQiKTsKKwkJCWJyZWFrOwor
CQl9CisKKwkJaWYgKG1jX29wLnUubWNfZmV0Y2guZmxhZ3MgJiBYRU5fTUNfTk9EQVRBIHx8CisJ
CSAgICBtY19vcC51Lm1jX2ZldGNoLmZsYWdzICYgWEVOX01DX0ZFVENIRkFJTEVEKQorCQkJYnJl
YWs7CisJCWVsc2UgeworCQkJcmV0ID0gY29udmVydF9sb2coJmdfbWkpOworCQkJaWYgKHJldCkK
KwkJCQlwcl93YXJuaW5nKFhFTl9NQ0VMT0cKKwkJCQkJICAgIkZhaWxlZCB0byBjb252ZXJ0IHRo
aXMgZXJyb3IgbG9nLCAiCisJCQkJCSAgICJjb250aW51ZSBhY2tpbmcgaXQgYW55d2F5XG4iKTsK
KworCQkJbWNfb3AudS5tY19mZXRjaC5mbGFncyA9IGZsYWdzIHwgWEVOX01DX0FDSzsKKwkJCXJl
dCA9IEhZUEVSVklTT1JfbWNhKCZtY19vcCk7CisJCQlpZiAocmV0KSB7CisJCQkJcHJfZXJyKFhF
Tl9NQ0VMT0cKKwkJCQkgICAgICAgIkZhaWxlZCB0byBhY2sgcHJldmlvdXMgZXJyb3IgbG9nXG4i
KTsKKwkJCQlicmVhazsKKwkJCX0KKwkJfQorCX0gd2hpbGUgKDEpOworCisJcmV0dXJuIHJldDsK
K30KKworLyogdmlycSBoYW5kbGVyIGZvciBtYWNoaW5lIGNoZWNrIGVycm9yIGluZm8qLworc3Rh
dGljIGlycXJldHVybl90IHhlbl9tY2VfaW50ZXJydXB0KGludCBpcnEsIHZvaWQgKmRldl9pZCkK
K3sKKwlpbnQgZXJyOworCXVuc2lnbmVkIGxvbmcgdG1wOworCisJc3Bpbl9sb2NrX2lycXNhdmUo
Jm1jZWxvZ19sb2NrLCB0bXApOworCisJLyogdXJnZW50IG1jX2luZm8gKi8KKwllcnIgPSBtY19x
dWV1ZV9oYW5kbGUoWEVOX01DX1VSR0VOVCk7CisJaWYgKGVycikKKwkJcHJfZXJyKFhFTl9NQ0VM
T0cKKwkJICAgICAgICJGYWlsZWQgdG8gaGFuZGxlIHVyZ2VudCBtY19pbmZvIHF1ZXVlLCAiCisJ
CSAgICAgICAiY29udGludWUgaGFuZGxpbmcgbm9udXJnZW50IG1jX2luZm8gcXVldWUgYW55d2F5
LlxuIik7CisKKwkvKiBub251cmdlbnQgbWNfaW5mbyAqLworCWVyciA9IG1jX3F1ZXVlX2hhbmRs
ZShYRU5fTUNfTk9OVVJHRU5UKTsKKwlpZiAoZXJyKQorCQlwcl9lcnIoWEVOX01DRUxPRworCQkg
ICAgICAgIkZhaWxlZCB0byBoYW5kbGUgbm9udXJnZW50IG1jX2luZm8gcXVldWUuXG4iKTsKKwor
CXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJm1jZWxvZ19sb2NrLCB0bXApOworCisJcmV0dXJuIElS
UV9IQU5ETEVEOworfQorCitzdGF0aWMgaW50IGJpbmRfdmlycV9mb3JfbWNlKHZvaWQpCit7CisJ
aW50IHJldDsKKwlzdHJ1Y3QgeGVuX21jIG1jX29wOworCisJbWVtc2V0KCZtY19vcCwgMCwgc2l6
ZW9mKHN0cnVjdCB4ZW5fbWMpKTsKKworCS8qIEZldGNoIHBoeXNpY2FsIENQVSBOdW1iZXJzICov
CisJbWNfb3AuY21kID0gWEVOX01DX3BoeXNjcHVpbmZvOworCW1jX29wLmludGVyZmFjZV92ZXJz
aW9uID0gWEVOX01DQV9JTlRFUkZBQ0VfVkVSU0lPTjsKKwlzZXRfeGVuX2d1ZXN0X2hhbmRsZSht
Y19vcC51Lm1jX3BoeXNjcHVpbmZvLmluZm8sIGdfcGh5c2luZm8pOworCXJldCA9IEhZUEVSVklT
T1JfbWNhKCZtY19vcCk7CisJaWYgKHJldCkgeworCQlwcl9lcnIoWEVOX01DRUxPRyAiRmFpbGVk
IHRvIGdldCBDUFUgbnVtYmVyc1xuIik7CisJCXJldHVybiByZXQ7CisJfQorCisJLyogRmV0Y2gg
ZWFjaCBDUFUgUGh5c2ljYWwgSW5mbyBmb3IgbGF0ZXIgcmVmZXJlbmNlKi8KKwluY3B1cyA9IG1j
X29wLnUubWNfcGh5c2NwdWluZm8ubmNwdXM7CisJZ19waHlzaW5mbyA9IGtjYWxsb2MobmNwdXMs
IHNpemVvZihzdHJ1Y3QgbWNpbmZvX2xvZ2ljYWxfY3B1KSwKKwkJCSAgICAgR0ZQX0tFUk5FTCk7
CisJaWYgKCFnX3BoeXNpbmZvKQorCQlyZXR1cm4gLUVOT01FTTsKKwlzZXRfeGVuX2d1ZXN0X2hh
bmRsZShtY19vcC51Lm1jX3BoeXNjcHVpbmZvLmluZm8sIGdfcGh5c2luZm8pOworCXJldCA9IEhZ
UEVSVklTT1JfbWNhKCZtY19vcCk7CisJaWYgKHJldCkgeworCQlwcl9lcnIoWEVOX01DRUxPRyAi
RmFpbGVkIHRvIGdldCBDUFUgaW5mb1xuIik7CisJCWtmcmVlKGdfcGh5c2luZm8pOworCQlyZXR1
cm4gcmV0OworCX0KKworCXJldCAgPSBiaW5kX3ZpcnFfdG9faXJxaGFuZGxlcihWSVJRX01DQSwg
MCwKKwkJCQkgICAgICAgeGVuX21jZV9pbnRlcnJ1cHQsIDAsICJtY2UiLCBOVUxMKTsKKwlpZiAo
cmV0IDwgMCkgeworCQlwcl9lcnIoWEVOX01DRUxPRyAiRmFpbGVkIHRvIGJpbmQgdmlycVxuIik7
CisJCWtmcmVlKGdfcGh5c2luZm8pOworCQlyZXR1cm4gcmV0OworCX0KKworCXJldHVybiAwOwor
fQorCitzdGF0aWMgaW50IF9faW5pdCB4ZW5fbGF0ZV9pbml0X21jZWxvZyh2b2lkKQoreworCS8q
IE9ubHkgRE9NMCBpcyByZXNwb25zaWJsZSBmb3IgTUNFIGxvZ2dpbmcgKi8KKwlpZiAoeGVuX2lu
aXRpYWxfZG9tYWluKCkpIHsKKwkJLyogcmVnaXN0ZXIgY2hhcmFjdGVyIGRldmljZSAvZGV2L21j
ZWxvZyBmb3IgeGVuIG1jZWxvZyAqLworCQlpZiAobWlzY19yZWdpc3RlcigmeGVuX21jZV9jaHJk
ZXZfZGV2aWNlKSkKKwkJCXJldHVybiAtRU5PREVWOworCQlyZXR1cm4gYmluZF92aXJxX2Zvcl9t
Y2UoKTsKKwl9CisKKwlyZXR1cm4gLUVOT0RFVjsKK30KK2RldmljZV9pbml0Y2FsbCh4ZW5fbGF0
ZV9pbml0X21jZWxvZyk7CmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L21pc2NkZXZpY2UuaCBi
L2luY2x1ZGUvbGludXgvbWlzY2RldmljZS5oCmluZGV4IDA1NDlkMjEuLmUwZGVlYjIgMTAwNjQ0
Ci0tLSBhL2luY2x1ZGUvbGludXgvbWlzY2RldmljZS5oCisrKyBiL2luY2x1ZGUvbGludXgvbWlz
Y2RldmljZS5oCkBAIC0zNSw2ICszNSw3IEBACiAjZGVmaW5lIE1QVF9NSU5PUgkJMjIwCiAjZGVm
aW5lIE1QVDJTQVNfTUlOT1IJCTIyMQogI2RlZmluZSBVSU5QVVRfTUlOT1IJCTIyMworI2RlZmlu
ZSBNSVNDX01DRUxPR19NSU5PUgkyMjcKICNkZWZpbmUgSFBFVF9NSU5PUgkJMjI4CiAjZGVmaW5l
IEZVU0VfTUlOT1IJCTIyOQogI2RlZmluZSBLVk1fTUlOT1IJCTIzMgpkaWZmIC0tZ2l0IGEvaW5j
bHVkZS94ZW4vaW50ZXJmYWNlL3hlbi1tY2EuaCBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS94ZW4t
bWNhLmgKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uNzNhNGVhNwotLS0gL2Rl
di9udWxsCisrKyBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS94ZW4tbWNhLmgKQEAgLTAsMCArMSwz
ODUgQEAKKy8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
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
OworCX0gdTsKK307CitERUZJTkVfR1VFU1RfSEFORExFX1NUUlVDVCh4ZW5fbWMpOworCisvKiBG
aWVsZHMgYXJlIHplcm8gd2hlbiBub3QgYXZhaWxhYmxlICovCitzdHJ1Y3QgeGVuX21jZSB7CisJ
X191NjQgc3RhdHVzOworCV9fdTY0IG1pc2M7CisJX191NjQgYWRkcjsKKwlfX3U2NCBtY2dzdGF0
dXM7CisJX191NjQgaXA7CisJX191NjQgdHNjOwkvKiBjcHUgdGltZSBzdGFtcCBjb3VudGVyICov
CisJX191NjQgdGltZTsJLyogd2FsbCB0aW1lX3Qgd2hlbiBlcnJvciB3YXMgZGV0ZWN0ZWQgKi8K
KwlfX3U4ICBjcHV2ZW5kb3I7CS8qIGNwdSB2ZW5kb3IgYXMgZW5jb2RlZCBpbiBzeXN0ZW0uaCAq
LworCV9fdTggIGluamVjdF9mbGFnczsJLyogc29mdHdhcmUgaW5qZWN0IGZsYWdzICovCisJX191
MTYgIHBhZDsKKwlfX3UzMiBjcHVpZDsJLyogQ1BVSUQgMSBFQVggKi8KKwlfX3U4ICBjczsJCS8q
IGNvZGUgc2VnbWVudCAqLworCV9fdTggIGJhbms7CS8qIG1hY2hpbmUgY2hlY2sgYmFuayAqLwor
CV9fdTggIGNwdTsJLyogY3B1IG51bWJlcjsgb2Jzb2xldGU7IHVzZSBleHRjcHUgbm93ICovCisJ
X191OCAgZmluaXNoZWQ7ICAgLyogZW50cnkgaXMgdmFsaWQgKi8KKwlfX3UzMiBleHRjcHU7CS8q
IGxpbnV4IGNwdSBudW1iZXIgdGhhdCBkZXRlY3RlZCB0aGUgZXJyb3IgKi8KKwlfX3UzMiBzb2Nr
ZXRpZDsJLyogQ1BVIHNvY2tldCBJRCAqLworCV9fdTMyIGFwaWNpZDsJLyogQ1BVIGluaXRpYWwg
YXBpYyBJRCAqLworCV9fdTY0IG1jZ2NhcDsJLyogTUNHQ0FQIE1TUjogbWFjaGluZSBjaGVjayBj
YXBhYmlsaXRpZXMgb2YgQ1BVICovCit9OworCisvKgorICogVGhpcyBzdHJ1Y3R1cmUgY29udGFp
bnMgYWxsIGRhdGEgcmVsYXRlZCB0byB0aGUgTUNFIGxvZy4gIEFsc28KKyAqIGNhcnJpZXMgYSBz
aWduYXR1cmUgdG8gbWFrZSBpdCBlYXNpZXIgdG8gZmluZCBmcm9tIGV4dGVybmFsCisgKiBkZWJ1
Z2dpbmcgdG9vbHMuICBFYWNoIGVudHJ5IGlzIG9ubHkgdmFsaWQgd2hlbiBpdHMgZmluaXNoZWQg
ZmxhZworICogaXMgc2V0LgorICovCisKKyNkZWZpbmUgWEVOX01DRV9MT0dfTEVOIDMyCisKK3N0
cnVjdCB4ZW5fbWNlX2xvZyB7CisJY2hhciBzaWduYXR1cmVbMTJdOyAvKiAiTUFDSElORUNIRUNL
IiAqLworCXVuc2lnbmVkIGxlbjsJICAgIC8qID0gWEVOX01DRV9MT0dfTEVOICovCisJdW5zaWdu
ZWQgbmV4dDsKKwl1bnNpZ25lZCBmbGFnczsKKwl1bnNpZ25lZCByZWNvcmRsZW47CS8qIGxlbmd0
aCBvZiBzdHJ1Y3QgeGVuX21jZSAqLworCXN0cnVjdCB4ZW5fbWNlIGVudHJ5W1hFTl9NQ0VfTE9H
X0xFTl07Cit9OworCisjZGVmaW5lIFhFTl9NQ0VfT1ZFUkZMT1cgMAkJLyogYml0IDAgaW4gZmxh
Z3MgbWVhbnMgb3ZlcmZsb3cgKi8KKworI2RlZmluZSBYRU5fTUNFX0xPR19TSUdOQVRVUkUJIk1B
Q0hJTkVDSEVDSyIKKworI2RlZmluZSBNQ0VfR0VUX1JFQ09SRF9MRU4gICBfSU9SKCdNJywgMSwg
aW50KQorI2RlZmluZSBNQ0VfR0VUX0xPR19MRU4gICAgICBfSU9SKCdNJywgMiwgaW50KQorI2Rl
ZmluZSBNQ0VfR0VUQ0xFQVJfRkxBR1MgICBfSU9SKCdNJywgMywgaW50KQorCisjZW5kaWYgLyog
X19BU1NFTUJMWV9fICovCisjZW5kaWYgLyogX19YRU5fUFVCTElDX0FSQ0hfWDg2X01DQV9IX18g
Ki8KLS0gCjEuNy4xCgo=

--_002_DE8DF0795D48FD4CA783C40EC82923351F44F3SHSMSX101ccrcorpi_--
