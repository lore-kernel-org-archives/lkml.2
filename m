Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab1CLVWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 16:22:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53644 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422Ab1CLVWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 16:22:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/8] ACPI: Use syscore_ops instead of sysdev class and sysdev
Date: Sat, 12 Mar 2011 22:16:51 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
References: <201103100131.58206.rjw@sisk.pl> <201103122212.40828.rjw@sisk.pl>
In-Reply-To: <201103122212.40828.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103122216.51858.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

ACPI uses a sysdev class and a sysdev for executing
irqrouter_resume() before turning on interrupts on the boot CPU.
However, since irqrouter_resume() ignores its argument, the entire
mechanism may be replaced with a struct syscore_ops object which
is considerably simpler.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/pci_link.c |   30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

Index: linux-2.6/drivers/acpi/pci_link.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_link.c
+++ linux-2.6/drivers/acpi/pci_link.c
@@ -29,7 +29,7 @@
  *	   for IRQ management (e.g. start()->_SRS).
  */
 
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -757,14 +757,13 @@ static int acpi_pci_link_resume(struct a
 	return 0;
 }
 
-static int irqrouter_resume(struct sys_device *dev)
+static void irqrouter_resume(void)
 {
 	struct acpi_pci_link *link;
 
 	list_for_each_entry(link, &acpi_link_list, list) {
 		acpi_pci_link_resume(link);
 	}
-	return 0;
 }
 
 static int acpi_pci_link_remove(struct acpi_device *device, int type)
@@ -871,32 +870,19 @@ static int __init acpi_irq_balance_set(c
 
 __setup("acpi_irq_balance", acpi_irq_balance_set);
 
-/* FIXME: we will remove this interface after all drivers call pci_disable_device */
-static struct sysdev_class irqrouter_sysdev_class = {
-	.name = "irqrouter",
+static struct syscore_ops irqrouter_syscore_ops = {
 	.resume = irqrouter_resume,
 };
 
-static struct sys_device device_irqrouter = {
-	.id = 0,
-	.cls = &irqrouter_sysdev_class,
-};
-
-static int __init irqrouter_init_sysfs(void)
+static int __init irqrouter_init_ops(void)
 {
-	int error;
+	if (!acpi_disabled && !acpi_noirq)
+		register_syscore_ops(&irqrouter_syscore_ops);
 
-	if (acpi_disabled || acpi_noirq)
-		return 0;
-
-	error = sysdev_class_register(&irqrouter_sysdev_class);
-	if (!error)
-		error = sysdev_register(&device_irqrouter);
-
-	return error;
+	return 0;
 }
 
-device_initcall(irqrouter_init_sysfs);
+device_initcall(irqrouter_init_ops);
 
 static int __init acpi_pci_link_init(void)
 {

