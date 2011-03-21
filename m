Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab1CUXjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:39:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51873 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222Ab1CUXjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:39:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/6] PCI / Intel IOMMU: Use syscore_ops instead of sysdev class and sysdev
Date: Tue, 22 Mar 2011 00:36:17 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>, mingo@redhat.com,
        tglx@linutronix.de, Dave Jones <davej@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>, Avi Kivity <avi@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, cpufreq@vger.kernel.org
References: <201103100131.58206.rjw@sisk.pl> <201103122212.40828.rjw@sisk.pl> <201103220031.22729.rjw@sisk.pl>
In-Reply-To: <201103220031.22729.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103220036.17824.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The Intel IOMMU subsystem uses a sysdev class and a sysdev for
executing iommu_suspend() after interrupts have been turned off
on the boot CPU (during system suspend) and for executing
iommu_resume() before turning on interrupts on the boot CPU
(during system resume).  However, since both of these functions
ignore their arguments, the entire mechanism may be replaced with a
struct syscore_ops object which is simpler.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/intel-iommu.c |   38 +++++++++-----------------------------
 1 file changed, 9 insertions(+), 29 deletions(-)

Index: linux-2.6/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.orig/drivers/pci/intel-iommu.c
+++ linux-2.6/drivers/pci/intel-iommu.c
@@ -36,7 +36,7 @@
 #include <linux/iova.h>
 #include <linux/iommu.h>
 #include <linux/intel-iommu.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/tboot.h>
 #include <linux/dmi.h>
 #include <asm/cacheflush.h>
@@ -3135,7 +3135,7 @@ static void iommu_flush_all(void)
 	}
 }
 
-static int iommu_suspend(struct sys_device *dev, pm_message_t state)
+static int iommu_suspend(void)
 {
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu = NULL;
@@ -3175,7 +3175,7 @@ nomem:
 	return -ENOMEM;
 }
 
-static int iommu_resume(struct sys_device *dev)
+static void iommu_resume(void)
 {
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu = NULL;
@@ -3183,7 +3183,7 @@ static int iommu_resume(struct sys_devic
 
 	if (init_iommu_hw()) {
 		WARN(1, "IOMMU setup failed, DMAR can not resume!\n");
-		return -EIO;
+		return;
 	}
 
 	for_each_active_iommu(iommu, drhd) {
@@ -3204,40 +3204,20 @@ static int iommu_resume(struct sys_devic
 
 	for_each_active_iommu(iommu, drhd)
 		kfree(iommu->iommu_state);
-
-	return 0;
 }
 
-static struct sysdev_class iommu_sysclass = {
-	.name		= "iommu",
+static struct syscore_ops iommu_syscore_ops = {
 	.resume		= iommu_resume,
 	.suspend	= iommu_suspend,
 };
 
-static struct sys_device device_iommu = {
-	.cls	= &iommu_sysclass,
-};
-
-static int __init init_iommu_sysfs(void)
+static void __init init_iommu_pm_ops(void)
 {
-	int error;
-
-	error = sysdev_class_register(&iommu_sysclass);
-	if (error)
-		return error;
-
-	error = sysdev_register(&device_iommu);
-	if (error)
-		sysdev_class_unregister(&iommu_sysclass);
-
-	return error;
+	register_syscore_ops(&iommu_syscore_ops);
 }
 
 #else
-static int __init init_iommu_sysfs(void)
-{
-	return 0;
-}
+static inline int init_iommu_pm_ops(void) { }
 #endif	/* CONFIG_PM */
 
 /*
@@ -3320,7 +3300,7 @@ int __init intel_iommu_init(void)
 #endif
 	dma_ops = &intel_dma_ops;
 
-	init_iommu_sysfs();
+	init_iommu_pm_ops();
 
 	register_iommu(&intel_iommu_ops);
 

