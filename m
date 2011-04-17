Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1DQVRF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 17:17:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57681 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab1DQVQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 17:16:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/14] ARM / Integrator: Use struct syscore_ops for core PM
Date: Sun, 17 Apr 2011 23:09:00 +0200
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
Message-Id: <201104172309.00726.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Replace the sysdev class and struct sys_device used for power
management by the Integrator interrupt-handling code with a
struct syscore_ops object which is simpler.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-integrator/integrator_ap.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/arm/mach-integrator/integrator_ap.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-integrator/integrator_ap.c
+++ linux-2.6/arch/arm/mach-integrator/integrator_ap.c
@@ -24,7 +24,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/kmi.h>
 #include <linux/clocksource.h>
@@ -180,13 +180,13 @@ static void __init ap_init_irq(void)
 #ifdef CONFIG_PM
 static unsigned long ic_irq_enable;
 
-static int irq_suspend(struct sys_device *dev, pm_message_t state)
+static int irq_suspend(void)
 {
 	ic_irq_enable = readl(VA_IC_BASE + IRQ_ENABLE);
 	return 0;
 }
 
-static int irq_resume(struct sys_device *dev)
+static void irq_resume(void)
 {
 	/* disable all irq sources */
 	writel(-1, VA_CMIC_BASE + IRQ_ENABLE_CLEAR);
@@ -194,33 +194,25 @@ static int irq_resume(struct sys_device
 	writel(-1, VA_IC_BASE + FIQ_ENABLE_CLEAR);
 
 	writel(ic_irq_enable, VA_IC_BASE + IRQ_ENABLE_SET);
-	return 0;
 }
 #else
 #define irq_suspend NULL
 #define irq_resume NULL
 #endif
 
-static struct sysdev_class irq_class = {
-	.name		= "irq",
+static struct syscore_ops irq_syscore_ops = {
 	.suspend	= irq_suspend,
 	.resume		= irq_resume,
 };
 
-static struct sys_device irq_device = {
-	.id	= 0,
-	.cls	= &irq_class,
-};
-
-static int __init irq_init_sysfs(void)
+static int __init irq_syscore_init(void)
 {
-	int ret = sysdev_class_register(&irq_class);
-	if (ret == 0)
-		ret = sysdev_register(&irq_device);
-	return ret;
+	register_syscore_ops(&irq_syscore_ops);
+
+	return 0;
 }
 
-device_initcall(irq_init_sysfs);
+device_initcall(irq_syscore_init);
 
 /*
  * Flash handling.

