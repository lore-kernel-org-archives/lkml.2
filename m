Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab1CMNFG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 09:05:06 -0400
Received: from mail.fuw.edu.pl ([193.0.80.14]:42214 "EHLO mail.fuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756420Ab1CMNFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 09:05:01 -0400
From: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 9/10] sh: Use struct syscore_ops instead of sysdev class and sysdev
Date: Sun, 13 Mar 2011 14:03:49 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc8+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
References: <201103100131.58206.rjw@sisk.pl> <201103122212.40828.rjw@sisk.pl> <201103131402.48129.rjw@sisk.pl>
In-Reply-To: <201103131402.48129.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103131403.49561.rwys@fuw.edu.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Convert the SuperH clocks framework and shared interrupt handling
code to using struct syscore_ops instead of a sysdev classes and
sysdevs for power managment.

This reduces the code size significantly and simplifies it.  The
optimizations causing things not to be restored after creating a
hibernation image are removed, but they might lead to undesirable
effects during resume from hibernation (e.g. the clocks would be left
as the boot kernel set them, which might be not the same way as the
hibernated kernel had seen them before the hibernation).

This also is necessary for removing sysdevs from the kernel entirely
in the future.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/sh/clk/core.c       |   68 +++++++--------------------
 drivers/sh/intc/core.c      |  108 ++++++++++++++------------------------------
 drivers/sh/intc/internals.h |    2 
 3 files changed, 53 insertions(+), 125 deletions(-)

Index: linux-2.6/drivers/sh/clk/core.c
===================================================================
--- linux-2.6.orig/drivers/sh/clk/core.c
+++ linux-2.6/drivers/sh/clk/core.c
@@ -21,7 +21,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/seq_file.h>
 #include <linux/err.h>
 #include <linux/io.h>
@@ -630,68 +630,36 @@ long clk_round_parent(struct clk *clk, u
 EXPORT_SYMBOL_GPL(clk_round_parent);
 
 #ifdef CONFIG_PM
-static int clks_sysdev_suspend(struct sys_device *dev, pm_message_t state)
+static void clks_core_resume(void)
 {
-	static pm_message_t prev_state;
 	struct clk *clkp;
 
-	switch (state.event) {
-	case PM_EVENT_ON:
-		/* Resumeing from hibernation */
-		if (prev_state.event != PM_EVENT_FREEZE)
-			break;
-
-		list_for_each_entry(clkp, &clock_list, node) {
-			if (likely(clkp->ops)) {
-				unsigned long rate = clkp->rate;
-
-				if (likely(clkp->ops->set_parent))
-					clkp->ops->set_parent(clkp,
-						clkp->parent);
-				if (likely(clkp->ops->set_rate))
-					clkp->ops->set_rate(clkp, rate);
-				else if (likely(clkp->ops->recalc))
-					clkp->rate = clkp->ops->recalc(clkp);
-			}
+	list_for_each_entry(clkp, &clock_list, node) {
+		if (likely(clkp->ops)) {
+			unsigned long rate = clkp->rate;
+
+			if (likely(clkp->ops->set_parent))
+				clkp->ops->set_parent(clkp,
+					clkp->parent);
+			if (likely(clkp->ops->set_rate))
+				clkp->ops->set_rate(clkp, rate);
+			else if (likely(clkp->ops->recalc))
+				clkp->rate = clkp->ops->recalc(clkp);
 		}
-		break;
-	case PM_EVENT_FREEZE:
-		break;
-	case PM_EVENT_SUSPEND:
-		break;
 	}
-
-	prev_state = state;
-	return 0;
-}
-
-static int clks_sysdev_resume(struct sys_device *dev)
-{
-	return clks_sysdev_suspend(dev, PMSG_ON);
 }
 
-static struct sysdev_class clks_sysdev_class = {
-	.name = "clks",
-};
-
-static struct sysdev_driver clks_sysdev_driver = {
-	.suspend = clks_sysdev_suspend,
-	.resume = clks_sysdev_resume,
-};
-
-static struct sys_device clks_sysdev_dev = {
-	.cls = &clks_sysdev_class,
+static struct syscore_ops clks_syscore_ops = {
+	.resume = clks_core_resume,
 };
 
-static int __init clk_sysdev_init(void)
+static int __init clk_syscore_init(void)
 {
-	sysdev_class_register(&clks_sysdev_class);
-	sysdev_driver_register(&clks_sysdev_class, &clks_sysdev_driver);
-	sysdev_register(&clks_sysdev_dev);
+	register_syscore_ops(&clks_syscore_ops);
 
 	return 0;
 }
-subsys_initcall(clk_sysdev_init);
+subsys_initcall(clk_syscore_init);
 #endif
 
 /*
Index: linux-2.6/drivers/sh/intc/core.c
===================================================================
--- linux-2.6.orig/drivers/sh/intc/core.c
+++ linux-2.6/drivers/sh/intc/core.c
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/sh_intc.h>
-#include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/radix-tree.h>
@@ -376,108 +376,70 @@ err0:
 	return -ENOMEM;
 }
 
-static ssize_t
-show_intc_name(struct sys_device *dev, struct sysdev_attribute *attr, char *buf)
+static int intc_suspend(void)
 {
 	struct intc_desc_int *d;
 
-	d = container_of(dev, struct intc_desc_int, sysdev);
+	list_for_each_entry(d, &intc_list, list) {
+		int irq;
 
-	return sprintf(buf, "%s\n", d->chip.name);
-}
+		/* enable wakeup irqs belonging to this intc controller */
+		for_each_active_irq(irq) {
+			struct irq_data *data;
+			struct irq_desc *desc;
+			struct irq_chip *chip;
+
+			data = irq_get_irq_data(irq);
+			chip = irq_data_get_irq_chip(data);
+			if (chip != &d->chip)
+				continue;
+			desc = irq_to_desc(irq);
+			if ((desc->status & IRQ_WAKEUP))
+				chip->irq_enable(data);
+		}
+	}
 
-static SYSDEV_ATTR(name, S_IRUGO, show_intc_name, NULL);
+	return 0;
+}
 
-static int intc_suspend(struct sys_device *dev, pm_message_t state)
+static void intc_resume(void)
 {
 	struct intc_desc_int *d;
-	struct irq_data *data;
-	struct irq_desc *desc;
-	struct irq_chip *chip;
-	int irq;
-
-	/* get intc controller associated with this sysdev */
-	d = container_of(dev, struct intc_desc_int, sysdev);
-
-	switch (state.event) {
-	case PM_EVENT_ON:
-		if (d->state.event != PM_EVENT_FREEZE)
-			break;
+
+	list_for_each_entry(d, &intc_list, list) {
+		int irq;
 
 		for_each_active_irq(irq) {
-			desc = irq_to_desc(irq);
+			struct irq_data *data;
+			struct irq_desc *desc;
+			struct irq_chip *chip;
+
 			data = irq_get_irq_data(irq);
 			chip = irq_data_get_irq_chip(data);
-
 			/*
 			 * This will catch the redirect and VIRQ cases
 			 * due to the dummy_irq_chip being inserted.
 			 */
 			if (chip != &d->chip)
 				continue;
+			desc = irq_to_desc(irq);
 			if (desc->status & IRQ_DISABLED)
 				chip->irq_disable(data);
 			else
 				chip->irq_enable(data);
 		}
-		break;
-	case PM_EVENT_FREEZE:
-		/* nothing has to be done */
-		break;
-	case PM_EVENT_SUSPEND:
-		/* enable wakeup irqs belonging to this intc controller */
-		for_each_active_irq(irq) {
-			desc = irq_to_desc(irq);
-			data = irq_get_irq_data(irq);
-			chip = irq_data_get_irq_chip(data);
-
-			if (chip != &d->chip)
-				continue;
-			if ((desc->status & IRQ_WAKEUP))
-				chip->irq_enable(data);
-		}
-		break;
 	}
-
-	d->state = state;
-
-	return 0;
 }
 
-static int intc_resume(struct sys_device *dev)
-{
-	return intc_suspend(dev, PMSG_ON);
-}
-
-struct sysdev_class intc_sysdev_class = {
-	.name		= "intc",
+struct syscore_ops intc_syscore_ops = {
 	.suspend	= intc_suspend,
 	.resume		= intc_resume,
 };
 
-/* register this intc as sysdev to allow suspend/resume */
-static int __init register_intc_sysdevs(void)
+static int __init intc_syscore_init(void)
 {
-	struct intc_desc_int *d;
-	int error;
+	register_syscore_ops(&intc_syscore_ops);
 
-	error = sysdev_class_register(&intc_sysdev_class);
-	if (!error) {
-		list_for_each_entry(d, &intc_list, list) {
-			d->sysdev.id = d->index;
-			d->sysdev.cls = &intc_sysdev_class;
-			error = sysdev_register(&d->sysdev);
-			if (error == 0)
-				error = sysdev_create_file(&d->sysdev,
-							   &attr_name);
-			if (error)
-				break;
-		}
-	}
-
-	if (error)
-		pr_err("sysdev registration error\n");
-
-	return error;
+	return 0;
 }
-device_initcall(register_intc_sysdevs);
+device_initcall(intc_syscore_init);
Index: linux-2.6/drivers/sh/intc/internals.h
===================================================================
--- linux-2.6.orig/drivers/sh/intc/internals.h
+++ linux-2.6/drivers/sh/intc/internals.h
@@ -51,9 +51,7 @@ struct intc_subgroup_entry {
 
 struct intc_desc_int {
 	struct list_head list;
-	struct sys_device sysdev;
 	struct radix_tree_root tree;
-	pm_message_t state;
 	raw_spinlock_t lock;
 	unsigned int index;
 	unsigned long *reg;

