Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1DQVSD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 17:18:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57784 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab1DQVQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 17:16:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/14] PM / PowerPC: Use struct syscore_ops instead of sysdevs for PM
Date: Sun, 17 Apr 2011 23:14:26 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, linux-arm-kernel@lists.infradead.org,
        Ben Dooks <ben-linux@fluff.org>, Mike Frysinger <vapier@gentoo.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, Jiri Kosina <jkosina@suse.cz>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
References: <201103280125.11750.rjw@sisk.pl> <201104172301.54115.rjw@sisk.pl>
In-Reply-To: <201104172301.54115.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104172314.27023.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make some PowerPC architecture's code use struct syscore_ops
objects for power management instead of sysdev classes and sysdevs.

This simplifies the code and reduces the kernel's memory footprint.
It also is necessary for removing sysdevs from the kernel entirely in
the future.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/powerpc/include/asm/mpic.h        |    3 --
 arch/powerpc/platforms/cell/spu_base.c |   28 ++++++++++++-------
 arch/powerpc/platforms/powermac/pic.c  |   42 +++++++---------------------
 arch/powerpc/sysdev/ipic.c             |   36 ++++++------------------
 arch/powerpc/sysdev/mpic.c             |   48 +++++++++++++++++----------------
 5 files changed, 64 insertions(+), 93 deletions(-)

Index: linux-2.6/arch/powerpc/platforms/powermac/pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/powermac/pic.c
+++ linux-2.6/arch/powerpc/platforms/powermac/pic.c
@@ -21,7 +21,7 @@
 #include <linux/signal.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/adb.h>
 #include <linux/pmu.h>
 #include <linux/module.h>
@@ -677,7 +677,7 @@ not_found:
 	return viaint;
 }
 
-static int pmacpic_suspend(struct sys_device *sysdev, pm_message_t state)
+static int pmacpic_suspend(void)
 {
 	int viaint = pmacpic_find_viaint();
 
@@ -698,7 +698,7 @@ static int pmacpic_suspend(struct sys_de
         return 0;
 }
 
-static int pmacpic_resume(struct sys_device *sysdev)
+static void pmacpic_resume(void)
 {
 	int i;
 
@@ -709,39 +709,19 @@ static int pmacpic_resume(struct sys_dev
 	for (i = 0; i < max_real_irqs; ++i)
 		if (test_bit(i, sleep_save_mask))
 			pmac_unmask_irq(irq_get_irq_data(i));
-
-	return 0;
 }
 
-#endif /* CONFIG_PM && CONFIG_PPC32 */
-
-static struct sysdev_class pmacpic_sysclass = {
-	.name = "pmac_pic",
+static struct syscore_ops pmacpic_syscore_ops = {
+	.suspend	= pmacpic_suspend,
+	.resume		= pmacpic_resume,
 };
 
-static struct sys_device device_pmacpic = {
-	.id		= 0,
-	.cls		= &pmacpic_sysclass,
-};
-
-static struct sysdev_driver driver_pmacpic = {
-#if defined(CONFIG_PM) && defined(CONFIG_PPC32)
-	.suspend	= &pmacpic_suspend,
-	.resume		= &pmacpic_resume,
-#endif /* CONFIG_PM && CONFIG_PPC32 */
-};
-
-static int __init init_pmacpic_sysfs(void)
+static int __init init_pmacpic_syscore(void)
 {
-#ifdef CONFIG_PPC32
-	if (max_irqs == 0)
-		return -ENODEV;
-#endif
-	printk(KERN_DEBUG "Registering pmac pic with sysfs...\n");
-	sysdev_class_register(&pmacpic_sysclass);
-	sysdev_register(&device_pmacpic);
-	sysdev_driver_register(&pmacpic_sysclass, &driver_pmacpic);
+	register_syscore_ops(&pmacpic_syscore_ops);
 	return 0;
 }
-machine_subsys_initcall(powermac, init_pmacpic_sysfs);
 
+machine_subsys_initcall(powermac, init_pmacpic_syscore);
+
+#endif /* CONFIG_PM && CONFIG_PPC32 */
Index: linux-2.6/arch/powerpc/platforms/cell/spu_base.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spu_base.c
+++ linux-2.6/arch/powerpc/platforms/cell/spu_base.c
@@ -32,6 +32,7 @@
 #include <linux/io.h>
 #include <linux/mutex.h>
 #include <linux/linux_logo.h>
+#include <linux/syscore_ops.h>
 #include <asm/spu.h>
 #include <asm/spu_priv1.h>
 #include <asm/spu_csa.h>
@@ -521,18 +522,8 @@ void spu_init_channels(struct spu *spu)
 }
 EXPORT_SYMBOL_GPL(spu_init_channels);
 
-static int spu_shutdown(struct sys_device *sysdev)
-{
-	struct spu *spu = container_of(sysdev, struct spu, sysdev);
-
-	spu_free_irqs(spu);
-	spu_destroy_spu(spu);
-	return 0;
-}
-
 static struct sysdev_class spu_sysdev_class = {
 	.name = "spu",
-	.shutdown = spu_shutdown,
 };
 
 int spu_add_sysdev_attr(struct sysdev_attribute *attr)
@@ -797,6 +788,22 @@ static inline void crash_register_spus(s
 }
 #endif
 
+static void spu_shutdown(void)
+{
+	struct spu *spu;
+
+	mutex_lock(&spu_full_list_mutex);
+	list_for_each_entry(spu, &spu_full_list, full_list) {
+		spu_free_irqs(spu);
+		spu_destroy_spu(spu);
+	}
+	mutex_unlock(&spu_full_list_mutex);
+}
+
+static struct syscore_ops spu_syscore_ops = {
+	.shutdown = spu_shutdown,
+};
+
 static int __init init_spu_base(void)
 {
 	int i, ret = 0;
@@ -830,6 +837,7 @@ static int __init init_spu_base(void)
 	crash_register_spus(&spu_full_list);
 	mutex_unlock(&spu_full_list_mutex);
 	spu_add_sysdev_attr(&attr_stat);
+	register_syscore_ops(&spu_syscore_ops);
 
 	spu_init_affinity();
 
Index: linux-2.6/arch/powerpc/sysdev/ipic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/ipic.c
+++ linux-2.6/arch/powerpc/sysdev/ipic.c
@@ -18,7 +18,7 @@
 #include <linux/stddef.h>
 #include <linux/sched.h>
 #include <linux/signal.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/device.h>
 #include <linux/bootmem.h>
 #include <linux/spinlock.h>
@@ -902,7 +902,7 @@ static struct {
 	u32 sercr;
 } ipic_saved_state;
 
-static int ipic_suspend(struct sys_device *sdev, pm_message_t state)
+static int ipic_suspend(void)
 {
 	struct ipic *ipic = primary_ipic;
 
@@ -933,7 +933,7 @@ static int ipic_suspend(struct sys_devic
 	return 0;
 }
 
-static int ipic_resume(struct sys_device *sdev)
+static void ipic_resume(void)
 {
 	struct ipic *ipic = primary_ipic;
 
@@ -949,44 +949,26 @@ static int ipic_resume(struct sys_device
 	ipic_write(ipic->regs, IPIC_SECNR, ipic_saved_state.secnr);
 	ipic_write(ipic->regs, IPIC_SERMR, ipic_saved_state.sermr);
 	ipic_write(ipic->regs, IPIC_SERCR, ipic_saved_state.sercr);
-
-	return 0;
 }
 #else
 #define ipic_suspend NULL
 #define ipic_resume NULL
 #endif
 
-static struct sysdev_class ipic_sysclass = {
-	.name = "ipic",
+static struct syscore_ops ipic_syscore_ops = {
 	.suspend = ipic_suspend,
 	.resume = ipic_resume,
 };
 
-static struct sys_device device_ipic = {
-	.id		= 0,
-	.cls		= &ipic_sysclass,
-};
-
-static int __init init_ipic_sysfs(void)
+static int __init init_ipic_syscore(void)
 {
-	int rc;
-
 	if (!primary_ipic || !primary_ipic->regs)
 		return -ENODEV;
-	printk(KERN_DEBUG "Registering ipic with sysfs...\n");
 
-	rc = sysdev_class_register(&ipic_sysclass);
-	if (rc) {
-		printk(KERN_ERR "Failed registering ipic sys class\n");
-		return -ENODEV;
-	}
-	rc = sysdev_register(&device_ipic);
-	if (rc) {
-		printk(KERN_ERR "Failed registering ipic sys device\n");
-		return -ENODEV;
-	}
+	printk(KERN_DEBUG "Registering ipic system core operations\n");
+	register_syscore_ops(&ipic_syscore_ops);
+
 	return 0;
 }
 
-subsys_initcall(init_ipic_sysfs);
+subsys_initcall(init_ipic_syscore);
Index: linux-2.6/arch/powerpc/sysdev/mpic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/mpic.c
+++ linux-2.6/arch/powerpc/sysdev/mpic.c
@@ -27,6 +27,7 @@
 #include <linux/spinlock.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/ptrace.h>
 #include <asm/signal.h>
@@ -1702,9 +1703,8 @@ void mpic_reset_core(int cpu)
 #endif /* CONFIG_SMP */
 
 #ifdef CONFIG_PM
-static int mpic_suspend(struct sys_device *dev, pm_message_t state)
+static void mpic_suspend_one(struct mpic *mpic)
 {
-	struct mpic *mpic = container_of(dev, struct mpic, sysdev);
 	int i;
 
 	for (i = 0; i < mpic->num_sources; i++) {
@@ -1713,13 +1713,22 @@ static int mpic_suspend(struct sys_devic
 		mpic->save_data[i].dest =
 			mpic_irq_read(i, MPIC_INFO(IRQ_DESTINATION));
 	}
+}
+
+static int mpic_suspend(void)
+{
+	struct mpic *mpic = mpics;
+
+	while (mpic) {
+		mpic_suspend_one(mpic);
+		mpic = mpic->next;
+	}
 
 	return 0;
 }
 
-static int mpic_resume(struct sys_device *dev)
+static void mpic_resume_one(struct mpic *mpic)
 {
-	struct mpic *mpic = container_of(dev, struct mpic, sysdev);
 	int i;
 
 	for (i = 0; i < mpic->num_sources; i++) {
@@ -1746,33 +1755,28 @@ static int mpic_resume(struct sys_device
 	}
 #endif
 	} /* end for loop */
+}
 
-	return 0;
+static void mpic_resume(void)
+{
+	struct mpic *mpic = mpics;
+
+	while (mpic) {
+		mpic_resume_one(mpic);
+		mpic = mpic->next;
+	}
 }
-#endif
 
-static struct sysdev_class mpic_sysclass = {
-#ifdef CONFIG_PM
+static struct syscore_ops mpic_syscore_ops = {
 	.resume = mpic_resume,
 	.suspend = mpic_suspend,
-#endif
-	.name = "mpic",
 };
 
 static int mpic_init_sys(void)
 {
-	struct mpic *mpic = mpics;
-	int error, id = 0;
-
-	error = sysdev_class_register(&mpic_sysclass);
-
-	while (mpic && !error) {
-		mpic->sysdev.cls = &mpic_sysclass;
-		mpic->sysdev.id = id++;
-		error = sysdev_register(&mpic->sysdev);
-		mpic = mpic->next;
-	}
-	return error;
+	register_syscore_ops(&mpic_syscore_ops);
+	return 0;
 }
 
 device_initcall(mpic_init_sys);
+#endif
Index: linux-2.6/arch/powerpc/include/asm/mpic.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/mpic.h
+++ linux-2.6/arch/powerpc/include/asm/mpic.h
@@ -3,7 +3,6 @@
 #ifdef __KERNEL__
 
 #include <linux/irq.h>
-#include <linux/sysdev.h>
 #include <asm/dcr.h>
 #include <asm/msi_bitmap.h>
 
@@ -320,8 +319,6 @@ struct mpic
 	/* link */
 	struct mpic		*next;
 
-	struct sys_device	sysdev;
-
 #ifdef CONFIG_PM
 	struct mpic_irq_save	*save_data;
 #endif

