Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab1LIXo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:44:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51446 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab1LIXoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:44:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [RFC][PATCH 1/4] PM / shmobile: Don't include SH7372's INTCS in syscore suspend/resume
Date: Sat, 10 Dec 2011 00:43:52 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <201112100042.45168.rjw@sisk.pl>
In-Reply-To: <201112100042.45168.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112100043.53154.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since the SH7372's INTCS in included into syscore suspend/resume,
which causes the chip to be accessed when PM domains have been
turned off during system suspend, the A4R domain containing the
INTCS has to stay on during system sleep, which is suboptimal
from the power consumption point of view.

For this reason, add a new INTC flag, skip_syscore_suspend, to mark
the INTCS for intc_suspend() and intc_resume(), so that they don't
touch it.  This allows the A4R domain to be turned off during
system suspend and the INTCS state is resrored during system
resume by the A4R's "power on" code.

Suggested-by: Magnus Damm <damm@opensource.se>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/intc-sh7372.c |    1 +
 drivers/sh/intc/core.c               |    8 ++++++++
 drivers/sh/intc/internals.h          |    1 +
 include/linux/sh_intc.h              |    1 +
 4 files changed, 11 insertions(+)

Index: linux/include/linux/sh_intc.h
===================================================================
--- linux.orig/include/linux/sh_intc.h
+++ linux/include/linux/sh_intc.h
@@ -95,6 +95,7 @@ struct intc_desc {
 	unsigned int num_resources;
 	intc_enum force_enable;
 	intc_enum force_disable;
+	bool skip_syscore_suspend;
 	struct intc_hw_desc hw;
 };
 
Index: linux/arch/arm/mach-shmobile/intc-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/intc-sh7372.c
+++ linux/arch/arm/mach-shmobile/intc-sh7372.c
@@ -535,6 +535,7 @@ static struct resource intcs_resources[]
 static struct intc_desc intcs_desc __initdata = {
 	.name = "sh7372-intcs",
 	.force_enable = ENABLED_INTCS,
+	.skip_syscore_suspend = true,
 	.resource = intcs_resources,
 	.num_resources = ARRAY_SIZE(intcs_resources),
 	.hw = INTC_HW_DESC(intcs_vectors, intcs_groups, intcs_mask_registers,
Index: linux/drivers/sh/intc/core.c
===================================================================
--- linux.orig/drivers/sh/intc/core.c
+++ linux/drivers/sh/intc/core.c
@@ -354,6 +354,8 @@ int __init register_intc_controller(stru
 	if (desc->force_enable)
 		intc_enable_disable_enum(desc, d, desc->force_enable, 1);
 
+	d->skip_suspend = desc->skip_syscore_suspend;
+
 	nr_intc_controllers++;
 
 	return 0;
@@ -386,6 +388,9 @@ static int intc_suspend(void)
 	list_for_each_entry(d, &intc_list, list) {
 		int irq;
 
+		if (d->skip_suspend)
+			continue;
+
 		/* enable wakeup irqs belonging to this intc controller */
 		for_each_active_irq(irq) {
 			struct irq_data *data;
@@ -409,6 +414,9 @@ static void intc_resume(void)
 	list_for_each_entry(d, &intc_list, list) {
 		int irq;
 
+		if (d->skip_suspend)
+			continue;
+
 		for_each_active_irq(irq) {
 			struct irq_data *data;
 			struct irq_chip *chip;
Index: linux/drivers/sh/intc/internals.h
===================================================================
--- linux.orig/drivers/sh/intc/internals.h
+++ linux/drivers/sh/intc/internals.h
@@ -67,6 +67,7 @@ struct intc_desc_int {
 	struct intc_window *window;
 	unsigned int nr_windows;
 	struct irq_chip chip;
+	bool skip_suspend;
 };
 
 

