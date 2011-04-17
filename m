Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab1DQVSl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 17:18:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57754 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956Ab1DQVQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 17:16:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/14] PM / AVR32: Use struct syscore_ops instead of sysdevs for PM
Date: Sun, 17 Apr 2011 23:13:09 +0200
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
Message-Id: <201104172313.09712.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Convert some AVR32 architecture's code to using struct syscore_ops
objects for power management instead of sysdev classes and sysdevs.

This simplifies the code and reduces the kernel's memory footprint.
It also is necessary for removing sysdevs from the kernel entirely in
the future.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/avr32/mach-at32ap/intc.c |   38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

Index: linux-2.6/arch/avr32/mach-at32ap/intc.c
===================================================================
--- linux-2.6.orig/arch/avr32/mach-at32ap/intc.c
+++ linux-2.6/arch/avr32/mach-at32ap/intc.c
@@ -12,7 +12,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/platform_device.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/io.h>
 
@@ -21,7 +21,6 @@
 struct intc {
 	void __iomem		*regs;
 	struct irq_chip		chip;
-	struct sys_device	sysdev;
 #ifdef CONFIG_PM
 	unsigned long		suspend_ipr;
 	unsigned long		saved_ipr[64];
@@ -146,9 +145,8 @@ void intc_set_suspend_handler(unsigned l
 	intc0.suspend_ipr = offset;
 }
 
-static int intc_suspend(struct sys_device *sdev, pm_message_t state)
+static int intc_suspend(void)
 {
-	struct intc *intc = container_of(sdev, struct intc, sysdev);
 	int i;
 
 	if (unlikely(!irqs_disabled())) {
@@ -156,28 +154,25 @@ static int intc_suspend(struct sys_devic
 		return -EINVAL;
 	}
 
-	if (unlikely(!intc->suspend_ipr)) {
+	if (unlikely(!intc0.suspend_ipr)) {
 		pr_err("intc_suspend: suspend_ipr not initialized\n");
 		return -EINVAL;
 	}
 
 	for (i = 0; i < 64; i++) {
-		intc->saved_ipr[i] = intc_readl(intc, INTPR0 + 4 * i);
-		intc_writel(intc, INTPR0 + 4 * i, intc->suspend_ipr);
+		intc0.saved_ipr[i] = intc_readl(&intc0, INTPR0 + 4 * i);
+		intc_writel(&intc0, INTPR0 + 4 * i, intc0.suspend_ipr);
 	}
 
 	return 0;
 }
 
-static int intc_resume(struct sys_device *sdev)
+static int intc_resume(void)
 {
-	struct intc *intc = container_of(sdev, struct intc, sysdev);
 	int i;
 
-	WARN_ON(!irqs_disabled());
-
 	for (i = 0; i < 64; i++)
-		intc_writel(intc, INTPR0 + 4 * i, intc->saved_ipr[i]);
+		intc_writel(&intc0, INTPR0 + 4 * i, intc0.saved_ipr[i]);
 
 	return 0;
 }
@@ -186,27 +181,18 @@ static int intc_resume(struct sys_device
 #define intc_resume	NULL
 #endif
 
-static struct sysdev_class intc_class = {
-	.name		= "intc",
+static struct syscore_ops intc_syscore_ops = {
 	.suspend	= intc_suspend,
 	.resume		= intc_resume,
 };
 
-static int __init intc_init_sysdev(void)
+static int __init intc_init_syscore(void)
 {
-	int ret;
-
-	ret = sysdev_class_register(&intc_class);
-	if (ret)
-		return ret;
+	register_syscore_ops(&intc_syscore_ops);
 
-	intc0.sysdev.id = 0;
-	intc0.sysdev.cls = &intc_class;
-	ret = sysdev_register(&intc0.sysdev);
-
-	return ret;
+	return 0;
 }
-device_initcall(intc_init_sysdev);
+device_initcall(intc_init_syscore);
 
 unsigned long intc_get_pending(unsigned int group)
 {

