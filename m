Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab1CVUTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:19:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57452 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799Ab1CVUTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:19:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/10] sh: Use struct syscore_ops instead of sysdev class and sysdev
Date: Tue, 22 Mar 2011 21:19:28 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
References: <201103100131.58206.rjw@sisk.pl> <201103190147.28001.rjw@sisk.pl> <20110322140420.GA24004@linux-sh.org>
In-Reply-To: <20110322140420.GA24004@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103222119.28328.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 22, 2011, Paul Mundt wrote:
> On Sat, Mar 19, 2011 at 01:47:27AM +0100, Rafael J. Wysocki wrote:
> > On Thursday, March 17, 2011, Paul Mundt wrote:
> > > On Sun, Mar 13, 2011 at 02:03:49PM +0100, R. J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > Convert the SuperH clocks framework and shared interrupt handling
> > > > code to using struct syscore_ops instead of a sysdev classes and
> > > > sysdevs for power managment.
> > > > 
> > > > This reduces the code size significantly and simplifies it.  The
> > > > optimizations causing things not to be restored after creating a
> > > > hibernation image are removed, but they might lead to undesirable
> > > > effects during resume from hibernation (e.g. the clocks would be left
> > > > as the boot kernel set them, which might be not the same way as the
> > > > hibernated kernel had seen them before the hibernation).
> > > > 
> > > > This also is necessary for removing sysdevs from the kernel entirely
> > > > in the future.
> > > > 
> > > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > This misses the use of the sysdev class by the userimask code, though I'm
> > > open to suggestions for alternatives.
> > 
> > For now, I'd simply move the sysdev class definition to userimask.c, like
> > in the patch below.  The current goal is to eliminate the suspend/resume and
> > shutdown operations from sysdevs (and sysdev drivers), the next step will
> > be to replace the remaining sysdevs with alternative mechanisms.
> > 
> It's not quite that straightforward, you've also killed off the name
> attribute for each of the intc sysdevs, so we no longer have a visible
> way to map a given intc controller number to the controller name in a
> user visible way.

Hmm.  So you actually want those empty directories to show up in sysfs?
I didn't think they were really useful ...

> I'm not opposed to the syscore thing for suspend/resume ops, but I'm not
> willing to trash the userimask and name mapping interface in the process
> with no alternatives.

OK

> userimask was the first global configuration item I added, but there are
> other per-controller and global configuration knobs that I plan to export
> through the interface, so there really needs to be a compelling reason
> for moving off of sysdevs.

Yes, there is.  They are simply unusable in other situations, but I agree
we'll need to find a clean way to replace them where there's a good reason to
use them.

Updated patch follows.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: Drivers / sh: Use struct syscore_ops instead of sysdevs

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
 drivers/sh/clk/core.c       |   68 ++++++++-----------------------
 drivers/sh/intc/core.c      |   95 +++++++++++++++++++++-----------------------
 drivers/sh/intc/internals.h |    1 
 3 files changed, 65 insertions(+), 99 deletions(-)

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
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/sh_intc.h>
 #include <linux/sysdev.h>
+#include <linux/syscore_ops.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/radix-tree.h>
@@ -376,91 +377,89 @@ err0:
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
 
-static SYSDEV_ATTR(name, S_IRUGO, show_intc_name, NULL);
+			data = irq_get_irq_data(irq);
+			chip = irq_data_get_irq_chip(data);
+			if (chip != &d->chip)
+				continue;
+			desc = irq_to_desc(irq);
+			if ((desc->status & IRQ_WAKEUP))
+				chip->irq_enable(data);
+		}
+	}
+
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
 
-	switch (state.event) {
-	case PM_EVENT_ON:
-		if (d->state.event != PM_EVENT_FREEZE)
-			break;
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
+struct syscore_ops intc_syscore_ops = {
+	.suspend	= intc_suspend,
+	.resume		= intc_resume,
+};
 
 struct sysdev_class intc_sysdev_class = {
 	.name		= "intc",
-	.suspend	= intc_suspend,
-	.resume		= intc_resume,
 };
 
-/* register this intc as sysdev to allow suspend/resume */
+static ssize_t
+show_intc_name(struct sys_device *dev, struct sysdev_attribute *attr, char *buf)
+{
+	struct intc_desc_int *d;
+
+	d = container_of(dev, struct intc_desc_int, sysdev);
+
+	return sprintf(buf, "%s\n", d->chip.name);
+}
+
+static SYSDEV_ATTR(name, S_IRUGO, show_intc_name, NULL);
+
 static int __init register_intc_sysdevs(void)
 {
 	struct intc_desc_int *d;
 	int error;
 
+	register_syscore_ops(&intc_syscore_ops);
+
 	error = sysdev_class_register(&intc_sysdev_class);
 	if (!error) {
 		list_for_each_entry(d, &intc_list, list) {
Index: linux-2.6/drivers/sh/intc/internals.h
===================================================================
--- linux-2.6.orig/drivers/sh/intc/internals.h
+++ linux-2.6/drivers/sh/intc/internals.h
@@ -53,7 +53,6 @@ struct intc_desc_int {
 	struct list_head list;
 	struct sys_device sysdev;
 	struct radix_tree_root tree;
-	pm_message_t state;
 	raw_spinlock_t lock;
 	unsigned int index;
 	unsigned long *reg;
